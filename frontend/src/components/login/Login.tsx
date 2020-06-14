import 'react-native-gesture-handler';
import React, { useState } from 'react';
import { useApolloClient } from '@apollo/react-hooks';
import LoginView from './LoginView';
import { useAuth } from '../../hooks/auth/use-auth';
import { TokenAuthDocument, TokenAuthMutation } from '../../graphql/types';

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
      apolloClient.mutate<TokenAuthMutation>({
        mutation: TokenAuthDocument,
        variables: {
          password,
          email
        }
      })
      .then(async value => {
        if (value.data?.tokenAuth?.token && value.data?.tokenAuth?.user) {
          await auth.login(value.data.tokenAuth.token, value.data.tokenAuth.user);
          onLoginSuccess?.()
        } else {
          loginFailed()
        }
      })
      .catch(_ => loginFailed())
    }
  }

  function loginFailed(): void {
    setIsError(true);
    setIsLoading(false);
    onLoginFail?.();
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
