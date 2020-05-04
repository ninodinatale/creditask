import React, { useEffect, useState } from 'react';
import Login from './login/Login';
import { useAuth } from '../hooks/auth/use-auth';
import SplashScreen from './_shared/SplashScreen';
import { RefreshTokenDocument, RefreshTokenMutation } from '../graphql/graphql';
import { useApolloClient } from '@apollo/react-hooks';
import NavigationWrapper from './NavigationWrapper';

export default function AuthWrapper() {
  const {mutate} = useApolloClient();
  const {getJwt, logout, login} = useAuth();

  const [state, setState] = useState({isLoading: false, hasToken: false});

  useEffect(() => {
    determineIfJwtExists().catch(console.error)
  }, []);

  async function determineIfJwtExists() {
    const jwt = await getJwt();
    if (jwt) {
      await refreshJwt(jwt)
    } else {
      setUserHasNoToken()
    }
  }

  async function refreshJwt(jwt: string): Promise<void> {
    const response = await mutate({
      mutation: RefreshTokenDocument,
      variables: {
        token: jwt
      }
    });

    if (response.errors) {
      await logout();
      setUserHasNoToken()
    } else {
      const data: RefreshTokenMutation = response.data;
      if (data?.refreshToken?.token) {
        await login(data.refreshToken.token, data.refreshToken.payload);
        setUserHasToken()
      }
    }
  }

  function setUserHasToken(): void {
    setState({
      hasToken: true,
      isLoading: false
    });
  }

  function setUserHasNoToken(): void {
    setState({
      hasToken: false,
      isLoading: false
    });
  }


  if (state.isLoading) {
    return <SplashScreen/>
  }

  if (!state.hasToken) {
    return <Login onLoginSuccess={setUserHasToken}/>
  } else {
    return <NavigationWrapper/>
  }
}
