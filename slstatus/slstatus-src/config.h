/* See LICENSE file for copyright and license details. */

/* interval between updates (in ms) */
const unsigned int interval = 1000;

/* text to show if no value can be retrieved */
static const char unknown_str[] = "n/a";

/* maximum output string length */
#define MAXLEN 2048

/* symbols, colors */
// Battery
#define BATSYM "🔋"
// charging
#define GREEN "^c#A3D55F^"
#define BLUE "^c#6080D6^"
// discharging
#define YELLOW "^c#D6D660^"
// critical
#define RED "^c#D66360"
// low
#define ORANGE "^c#D67690"

static const char *colored_battery(const char *bat) {
  const char *perc_str = battery_perc(bat);
  if (!perc_str)
    return NULL;

  int perc = atoi(perc_str);
  if (perc < 20)
    return bprintf(RED "%d%%", perc);
  else if (perc < 40)
    return bprintf(ORANGE "%d%%", perc);
  else
    return bprintf("%d%%", perc);
}

static const char *colored_battery_state(const char *bat) {
  const char *state_str = battery_raw_state(bat);
  if (!state_str)
    return NULL;
  const char *state_sym = battery_state(bat);
  if (!state_sym)
    return NULL;

  if (strcmp(state_str, "Full") == 0)
    return bprintf(BLUE "%s^d^", state_sym);
  else if (strcmp(state_str, "Charging") == 0)
    return bprintf(GREEN "%s^d^", state_sym);
  else if (strcmp(state_str, "Discharging") == 0)
    return bprintf(YELLOW "%s^d^", state_sym);

  return bprintf("%s^d^", state_sym);
}

static const struct arg args[] = {
    /* function        format                               argument */
    {colored_battery, "^c6^|^d^ ^c7^🔋 %s^d^", "BAT0"},
    {colored_battery_state, " %s^d^", "BAT0"},
    {battery_remaining, " ^c7^(%s)^d^", "BAT0"},
    {ram_perc, " ^c2^|^d^  ^c7^%s%%^d^", NULL},
    {datetime, " ^c3^|^d^ ^c7^%s^d^", "%a %m/%d/%Y"},
    //{run_command, " ^c7^(%s)^d^",
    // "sh -c 'echo Winter 2026: $(($(date +%W) - 0))/10'"},
    {datetime, " ^c1^|^d^ ^c7^%s^d^ ", "%H:%M:%S"},
};
