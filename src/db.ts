import type {SQLiteDatabase} from 'expo-sqlite';
import type {Habit,HabitDraft,Completion} from './types';
import {localDay} from './date';
export async function migrate(db:SQLiteDatabase){
 await db.execAsync(`PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON;
 CREATE TABLE IF NOT EXISTS habits(id TEXT PRIMARY KEY NOT NULL,name TEXT NOT NULL,icon TEXT NOT NULL,color TEXT NOT NULL,days TEXT NOT NULL,reminder TEXT,created_at TEXT NOT NULL,archived INTEGER NOT NULL DEFAULT 0);
 CREATE TABLE IF NOT EXISTS completions(habit_id TEXT NOT NULL,day TEXT NOT NULL,PRIMARY KEY(habit_id,day),FOREIGN KEY(habit_id) REFERENCES habits(id) ON DELETE CASCADE);
 CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY NOT NULL,value TEXT NOT NULL);CREATE INDEX IF NOT EXISTS idx_comp_day ON completions(day);`);
}
export async function allHabits(db:SQLiteDatabase){return db.getAllAsync<Habit>('SELECT * FROM habits WHERE archived=0 ORDER BY created_at ASC');}
export async function allCompletions(db:SQLiteDatabase){return db.getAllAsync<Completion>('SELECT habit_id,day FROM completions');}
export async function habitById(db:SQLiteDatabase,id:string){return db.getFirstAsync<Habit>('SELECT * FROM habits WHERE id=?',id);}
export async function saveHabit(db:SQLiteDatabase, draft:HabitDraft,id?:string){const name=draft.name.trim();if(!name||name.length>65)throw new Error('Introduce un nombre de 1 a 65 caracteres.');if(!draft.days.length)throw new Error('Selecciona al menos un día.');if(id){await db.runAsync('UPDATE habits SET name=?,icon=?,color=?,days=?,reminder=? WHERE id=?',name,draft.icon,draft.color,JSON.stringify(draft.days),draft.reminder,id);return id;}const fresh=`h_${Date.now()}_${Math.random().toString(36).slice(2,8)}`;await db.runAsync('INSERT INTO habits(id,name,icon,color,days,reminder,created_at,archived) VALUES(?,?,?,?,?,?,?,0)',fresh,name,draft.icon,draft.color,JSON.stringify(draft.days),draft.reminder,localDay());return fresh;}
export async function setCompletion(db:SQLiteDatabase,habitId:string,day:string,done:boolean){if(done)await db.runAsync('INSERT OR IGNORE INTO completions(habit_id,day) VALUES(?,?)',habitId,day);else await db.runAsync('DELETE FROM completions WHERE habit_id=? AND day=?',habitId,day);}
export async function deleteHabit(db:SQLiteDatabase,id:string){await db.runAsync('DELETE FROM habits WHERE id=?',id);}
export async function clearDatabase(db:SQLiteDatabase){await db.execAsync('DELETE FROM completions;DELETE FROM habits;DELETE FROM settings;');}
