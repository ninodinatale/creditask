import React, { FunctionComponent } from 'react';
import {
  Keyboard,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  TouchableWithoutFeedback
} from 'react-native';

export const KeyboardScrollView: FunctionComponent = function KeyboardScrollView(props) {
  return (
      <KeyboardAvoidingView
          behavior={Platform.OS === 'ios' ? 'padding' : undefined}
          style={{flex: 1}}
      >
        <ScrollView>
          <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
            {props.children}
          </TouchableWithoutFeedback>
        </ScrollView>
      </KeyboardAvoidingView>
  );
};
