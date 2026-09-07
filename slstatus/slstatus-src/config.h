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
#define RED "^c#D66360^"
// low
#define ORANGE "^c#D67690^"

static const char *colored_battery(const char *bat) {
  const char *perc_str = battery_perc(bat);
  if (!perc_str)
    return "";

  int perc = atoi(perc_str);

  const char *perc_color = "^c7^";
  if (perc < 20)
    perc_color = RED;
  else if (perc < 40)
    perc_color = ORANGE;

  const char *state_str = battery_raw_state(bat);
  const char *state_sym = battery_state(bat);
  const char *state_color = "";

  if (state_str) {
    if (strcmp(state_str, "Full") == 0)
      state_color = BLUE;
    else if (strcmp(state_str, "Charging") == 0)
      state_color = GREEN;
    else if (strcmp(state_str, "Discharging") == 0)
      state_color = YELLOW;
  }

  const char *rem = battery_remaining(bat);
  char rem_str[64] = "";
  if (rem && *rem) {
    snprintf(rem_str, sizeof(rem_str), " ^c7^(%s)^d^", rem);
  }

  return bprintf("^c6^|^d^ ^c7^" BATSYM "^d^ %s%d%%^d^ %s%s^d^%s",
                 perc_color, perc,
                 state_color, state_sym ? state_sym : "",
                 rem_str);
}

static const struct arg args[] = {
    /* function        format                               argument */
    {colored_battery,  "%s",                                "BAT0"},
    {ram_perc,         " ^c2^|^d^  ^c7^%s%%^d^",            NULL},
    {datetime,         " ^c3^|^d^ ^c7^%s^d^",               "%a %m/%d/%Y"},
    //{run_command, " ^c7^(%s)^d^",
    // "sh -c 'echo Winter 2026: $(($(date +%W) - 0))/10'"},
    {datetime,         " ^c1^|^d^ ^c7^%s^d^ ",              "%H:%M:%S"},
};

