import * as Notifications from 'expo-notifications';
import {Platform} from 'react-native';
import type {Habit} from './types';
Notifications.setNotificationHandler({handleNotification:async()=>({shouldPlaySound:false,shouldSetBadge:false,shouldShowBanner:true,shouldShowList:true})});
export async function configureNotifications(){if(Platform.OS==='android')await Notifications.setNotificationChannelAsync('habits',{name:'Recordatorios',importance:Notifications.AndroidImportance.DEFAULT});}
export async function scheduleForHabit(habit:Habit){// Los identificadores reales se recuperan por el habitId guardado en data.
 const all=await Notifications.getAllScheduledNotificationsAsync();for(const item of all){if(item.content.data?.habitId===habit.id)await Notifications.cancelScheduledNotificationAsync(item.identifier);}
 if(!habit.reminder)return;const perm=await Notifications.getPermissionsAsync();let granted=perm.granted;if(!granted){const ask=await Notifications.requestPermissionsAsync();granted=ask.granted;}if(!granted)throw new Error('Activa las notificaciones en Ajustes para recibir recordatorios.');
 const [hour,minute]=habit.reminder.split(':').map(Number);const days:number[]=JSON.parse(habit.days);
 for(const day of days){await Notifications.scheduleNotificationAsync({content:{title:'Un pequeño paso hoy ✨',body:habit.name,data:{habitId:habit.id}},trigger:{type:Notifications.SchedulableTriggerInputTypes.WEEKLY,weekday:day+1,hour,minute,...(Platform.OS==='android'?{channelId:'habits'}:{})}});}
}
export async function cancelHabitNotifications(id:string){const all=await Notifications.getAllScheduledNotificationsAsync();for(const item of all){if(item.content.data?.habitId===id)await Notifications.cancelScheduledNotificationAsync(item.identifier);}}
export async function cancelAllHabitNotifications(){const all=await Notifications.getAllScheduledNotificationsAsync();for(const item of all){if(item.content.data?.habitId)await Notifications.cancelScheduledNotificationAsync(item.identifier);}}
