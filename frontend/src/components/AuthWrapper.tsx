import React, { useState } from 'react';
import Login from './login/Login';
import { useAuth } from '../hooks/auth/use-auth';
import { RefreshTokenDocument, RefreshTokenMutation } from '../graphql/types';
import { useApolloClient } from '@apollo/react-hooks';
import NavigationWrapper from './NavigationWrapper';
import LoadingSpinner from './_shared/LoadingSpinner';
import NetInfo from '@react-native-community/netinfo';
import { Text, View } from 'react-native';

export default function AuthWrapper() {
  const {mutate} = useApolloClient();
  const {getJwt, logout, login, user} = useAuth();

  const [state, setState] = useState({isLoading: true, hasToken: false});

  const netInfo = NetInfo.useNetInfo();

  if (!user) {
    determineIfJwtExists().catch(_ => setUserHasNoToken());
  }

  async function determineIfJwtExists() {
    const jwt = await getJwt();
    if (jwt) {
      await refreshJwt(jwt)
    } else {
      setUserHasNoToken()
    }
  }

  async function refreshJwt(jwt: string): Promise<void> {
    const response = await mutate<RefreshTokenMutation>({
      mutation: RefreshTokenDocument,
      variables: {
        token: jwt
      }
    });

    if (response.errors) {
      await logout();
      setUserHasNoToken()
    } else {
      if (response.data?.refreshToken?.token) {
        await login(response.data.refreshToken.token, response.data.refreshToken.payload);
        setUserHasToken()
      }
    }
  }

  function setUserHasToken(): void {
    if (!state.hasToken || state.isLoading) {
      setState({
        hasToken: true,
        isLoading: false
      });
    }
  }

  function setUserHasNoToken(): void {
    if (state.hasToken || state.isLoading) {
      setState({
        hasToken: false,
        isLoading: false
      });
    }
  }


  if (state.isLoading) {
    return <LoadingSpinner/>
  }

  if (!netInfo.isConnected) {
    return <View style={{
      height: '100%',
      flex: 1,
      flexDirection: 'row',
      justifyContent: 'center',
    }}>
      <Text style={{
        textAlignVertical: 'center',
        fontSize: 25
      }}>Du has kein Internet... 😵</Text>
    </View>
  }

  if (!state.hasToken) {
    return <Login onLoginSuccess={setUserHasToken}/>
  } else {
    return <NavigationWrapper/>
  }
}
