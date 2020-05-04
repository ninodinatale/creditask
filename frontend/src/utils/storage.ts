import { Platform } from 'react-native';
import * as SecureStore from 'expo-secure-store';

async function setItem(key: string, value: string): Promise<void> {
  if (Platform.OS === 'web') {
    localStorage.setItem(key, value)
  } else {
    await SecureStore.setItemAsync(key, value);
  }
}

async function getItem(key: string): Promise<string | null> {
  if (Platform.OS === 'web') {
    return Promise.resolve(localStorage.getItem(key))
  } else {
    return await SecureStore.getItemAsync(key);
  }
}

async function deleteItem(key: string): Promise<void> {
  if (Platform.OS === 'web') {
    localStorage.removeItem(key)
  } else {
    await SecureStore.deleteItemAsync(key);
  }
}

export {
  deleteItem,
  setItem,
  getItem
}
