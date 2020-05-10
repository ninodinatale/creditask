import React, {
  createContext,
  Dispatch,
  SetStateAction,
  useContext,
  useEffect,
  useState
} from 'react';
import * as SecureStore from 'expo-secure-store';
import { CurrentUser } from '../../models/CurrentUser';
import '../../utils/storage';
import * as CreditaskStorage from '../../utils/storage';

type LoginFn = (jwt: string, user: CurrentUser) => Promise<void>
type LogoutFn = () => void

type AuthContext = {
  user: CurrentUser,
  isLoggedIn: boolean
  getJwt: () => Promise<string | null>
  login: LoginFn,
  logout: () => Promise<void>
}

// @ts-ignore
const authContext: React.Context<AuthContext> = createContext({
  user: {id: '', email: '', publicName: ''},
  isLoggedIn: false,
  login: (jwat, user) => {
    console.error('Authentication context is not defined yet')
    return Promise.resolve()
  },
  logout: () => {
    console.error('Authentication context is not defined yet')
    return Promise.resolve()
  }
});

export function ProvideAuth({children}: { children: React.ReactElement }) {
  const auth = useProvideAuth();
  return <authContext.Provider value={auth}>{children}</authContext.Provider>;
}

export const useAuth = () => {
  return useContext(authContext);
};

function useProvideAuth(): AuthContext {
  const [user, setUser]: [CurrentUser | null, Dispatch<SetStateAction<any>>] = useState(null);

  const login = async (jwt: string, user: CurrentUser) => {
    await CreditaskStorage.setItem('creditask_jwt', jwt);

    // TODO make sure the ID is a string. It should be delivered as string from the backend since
    //  JS does not have big numbers, but it's okay for now.
    user.id = ''+user.id;
    setUser(user)
  };

  const logout = async () => {
    await CreditaskStorage.deleteItem('creditask_jwt');
    setUser(null)
  };

  const getJwt = async () => {
    return await CreditaskStorage.getItem('creditask_jwt');
  };

  useEffect(() => {
    if (user) {
      setUser(user);
    } else {
      setUser(null);
    }
  }, []);

  return {
    // @ts-ignore If user is null, it will be redirected to login page, so ignoring that i cannot
    // be null in order to not have to nullcheck everywhere
    user,
    getJwt,
    login,
    logout,
  };
}
