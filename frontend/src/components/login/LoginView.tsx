import 'react-native-gesture-handler';
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Button, HelperText, TextInput, Title } from 'react-native-paper';

export interface LoginViewProps {
  email: string;
  password: string;
  isLoading: boolean;
  isError: boolean;
  setEmail: (value: string) => void;
  setPassword: (value: string) => void;
  login: () => void;
}

export default function LoginView(props: LoginViewProps) {
  let {email, password, isError, isLoading, setEmail, setPassword, login} = props;

  return (
      <View style={styles.container}>
        <Title>Login</Title>
        <TextInput
            mode='outlined'
            label='Email'
            value={email}
            onChangeText={setEmail}
            style={styles.textInput}
            error={isError}
        />
        <TextInput
            secureTextEntry={true}
            mode='outlined'
            label='Passwort'
            value={password}
            onChangeText={setPassword}
            style={styles.textInput}
            error={isError}
        />
        <HelperText
            type="error"
            visible={isError}
        >
          Email oder Passwort falsch
        </HelperText>
        <Button
            mode="contained"
            onPress={login}
            style={styles.loginButton}
            loading={isLoading}
        >
          Einloggen
        </Button>
      </View>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingLeft: '10%',
    paddingRight: '10%',
    flex: 1,
    alignItems: 'stretch',
    justifyContent: 'center'
  },
  textInput: {
    marginTop: 20
  },
  loginButton: {
    marginTop: 20
  }
});
