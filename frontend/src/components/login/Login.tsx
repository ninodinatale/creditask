import 'react-native-gesture-handler';
import React, { useState } from 'react';
import { gql } from 'apollo-boost';
import { useApolloClient } from '@apollo/react-hooks';
import LoginView from './LoginView';
import { StackNavigationProp } from '@react-navigation/stack'
import { useAuth } from '../../hooks/auth/use-auth';

type LoginProps = {
  onLoginSuccess?: () => void
  onLoginFail?: () => void
}

export default function Login({onLoginFail, onLoginSuccess}: LoginProps) {
  // TODO move this to higher component
  const auth = useAuth();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const apolloClient = useApolloClient();

  function emailChange(value: string) {
    setIsError(false);
    setEmail(value);
  }

  function passwordChange(value: string) {
    setIsError(false);
    setPassword(value);
  }

  function login() {
    setIsError(false);
    if (!isLoading) {

      setIsLoading(true);
      apolloClient.mutate({
        mutation:
        gql`
            mutation tokenAuth($email: String!, $password: String!) {
                tokenAuth(email: $email, password: $password) {
                    token,
                    user {
                        email
                        publicName
                    }
                }
            }
        `,
        variables: {
          password,
          email
        }
      })
      .then(async value => {
        await auth.login(value.data.tokenAuth.token, value.data.tokenAuth.user);
        console.log('calling success...')
        onLoginSuccess?.()
      })
      .catch(e => {
        setIsError(true);
        onLoginFail?.();
        console.error(e);
      })
    }
  }

  return (
      <LoginView
          email={email}
          setEmail={emailChange}
          password={password}
          setPassword={passwordChange}
          isLoading={isLoading}
          isError={isError}
          login={login}
      />
  );
}
