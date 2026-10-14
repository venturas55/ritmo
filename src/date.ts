export function localDay(d=new Date()){const y=d.getFullYear();const m=String(d.getMonth()+1).padStart(2,'0');const day=String(d.getDate()).padStart(2,'0');return `${y}-${m}-${day}`;}
export function fromDay(s:string){const [y,m,d]=s.split('-').map(Number);return new Date(y,m-1,d,12);}
export function moveDay(day:string,delta:number){const d=fromDay(day);d.setDate(d.getDate()+delta);return localDay(d);}
export function isScheduled(days:string,day:string){try{return (JSON.parse(days) as number[]).includes(fromDay(day).getDay());}catch{return true;}}
export function percent(n:number,den:number){return den?Math.round(n/den*100):0;}
export function currentStreak(habit:{days:string,created_at:string},completions:Set<string>,today=localDay()){let day=today; if(isScheduled(habit.days,day)&&!completions.has(day)) day=moveDay(day,-1);let streak=0;for(let i=0;i<10000;i++){if(day<habit.created_at.substring(0,10))break;if(isScheduled(habit.days,day)){if(!completions.has(day))break;streak++;}day=moveDay(day,-1);}return streak;}
export function monthDays(year:number,month:number){return new Date(year,month+1,0).getDate();}
export function dayLabel(day:string){return fromDay(day).toLocaleDateString('es-ES',{day:'numeric',month:'long'});}
