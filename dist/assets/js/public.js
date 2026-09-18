const cfg=window.DAKY_CONFIG||{};const configured=cfg.supabaseUrl&&!cfg.supabaseUrl.startsWith('YOUR_');let client=null;if(configured&&window.supabase)client=window.supabase.createClient(cfg.supabaseUrl,cfg.supabaseAnonKey);
const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
async function demo(){return fetch('data/demo-stories.json').then(r=>r.json())}
async function getStories(){if(!client)return demo();const {data,error}=await client.from('stories').select('*').eq('status','published').lte('published_at',new Date().toISOString()).order('published_at',{ascending:false});if(error)throw error;return data}
async function getStory(slug){if(!client)return demo().then(x=>x.find(s=>s.slug===slug));const {data,error}=await client.from('stories').select('*').eq('slug',slug).eq('status','published').maybeSingle();if(error)throw error;return data}
window.DaKy={esc,getStories,getStory,configured};
