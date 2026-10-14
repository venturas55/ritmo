export type Habit={id:string;name:string;icon:string;color:string;days:string;reminder:string|null;created_at:string;archived:number};
export type Completion={habit_id:string;day:string};
export type HabitDraft={name:string;icon:string;color:string;days:number[];reminder:string|null};
