import React,{createContext,useContext,useEffect,useState,useCallback} from 'react';
import {useSQLiteContext} from 'expo-sqlite';import {useFocusEffect} from 'expo-router';import * as Haptics from 'expo-haptics';
import {allHabits,allCompletions,setCompletion} from './db';import {localDay} from './date';import type {Habit,Completion} from './types';
type State={habits:Habit[];completions:Completion[];loading:boolean;refresh:()=>Promise<void>;toggle:(id:string,day?:string)=>Promise<void>;isDone:(id:string,day:string)=>boolean};
const C=createContext<State|null>(null);
export function DataProvider({children}:{children:React.ReactNode}){const db=useSQLiteContext();const [habits,setHabits]=useState<Habit[]>([]);const [completions,setCompletions]=useState<Completion[]>([]);const [loading,setLoading]=useState(true);
const refresh=useCallback(async()=>{try{const [a,b]=await Promise.all([allHabits(db),allCompletions(db)]);setHabits(a);setCompletions(b);}finally{setLoading(false);}},[db]);
useEffect(()=>{refresh().catch(console.error);},[refresh]);
const isDone=(id:string,day:string)=>completions.some(c=>c.habit_id===id&&c.day===day);
const toggle=async(id:string,day=localDay())=>{const done=isDone(id,day);await setCompletion(db,id,day,!done);if(!done)Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success).catch(()=>{});await refresh();};
return <C.Provider value={{habits,completions,loading,refresh,toggle,isDone}}>{children}</C.Provider>}
export function useData(){const v=useContext(C);if(!v)throw new Error('DataProvider missing');return v;}
