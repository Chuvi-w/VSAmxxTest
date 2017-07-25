#include <amxmodx>
#include <amxmisc>

#define PLUGIN "WTF?!"
#define VERSION "1.0"
#define AUTHOR "____"


public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd("wtf","wtf");
}
public wtf(id)
{
	
}
