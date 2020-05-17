import 'react-native-gesture-handler';
import React from 'react';
import { DefaultTheme, Provider as PaperProvider, Colors, Theme } from 'react-native-paper';
import { NavigationContainer } from '@react-navigation/native';
import { ProvideAuth } from './src/hooks/auth/use-auth';
import AuthWrapper from './src/components/AuthWrapper';
import ApolloClient from 'apollo-boost';
import { ApolloProvider } from '@apollo/react-hooks';
import * as CreditaskStorage from './src/utils/storage'

// TODO implement toggle for light/dark theme
const theme: Theme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: '#6037c1',
    accent: '#5686e8',
  }
};

const apolloClient = new ApolloClient({
  uri: 'http://cd8ad2d4.ngrok.io/graphql', // TODO env var,
  request: async (operation) => {
      const token = await CreditaskStorage.getItem('creditask_jwt');
      operation.setContext({
        headers: {
          authorization: token ? `Jwt ${token}` : ''
        }
      })
  },
});


export default function App() {

  return (
      <ApolloProvider client={apolloClient}>
        <ProvideAuth>
          <PaperProvider theme={theme}>
            <NavigationContainer>
              <AuthWrapper/>
            </NavigationContainer>
          </PaperProvider>
        </ProvideAuth>
      </ApolloProvider>
  );
}
