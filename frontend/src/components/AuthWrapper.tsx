import React, { useEffect, useState } from 'react';
import Login from './login/Login';
import { useAuth } from '../hooks/auth/use-auth';
import SplashScreen from './_shared/SplashScreen';
import { RefreshTokenDocument, RefreshTokenMutation } from '../graphql/types';
import { useApolloClient } from '@apollo/react-hooks';
import NavigationWrapper from './NavigationWrapper';
import LoadingSpinner from './_shared/LoadingSpinner';

export default function AuthWrapper() {
  const {mutate} = useApolloClient();
  const {getJwt, logout, login} = useAuth();

  const [state, setState] = useState({isLoading: true, hasToken: false});

  useEffect(() => {
    determineIfJwtExists().catch(_ => setUserHasNoToken())
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
    return <LoadingSpinner/>
  }

  if (!state.hasToken) {
    return <Login onLoginSuccess={setUserHasToken}/>
  } else {
    return <NavigationWrapper/>
  }
}
