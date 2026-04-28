import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

ArrayList<String[]> events = new ArrayList<String[]>();

void setup() {
  size(960, 540);
  textAlign(LEFT, TOP);
  textSize(16);

  events.add(new String[] {"/", "https://example.com/", "32", "78", "true"});
  events.add(new String[] {"/pricing", "https://example.com/", "84", "96", "true"});
  events.add(new String[] {"/docs", "(direct)", "18", "40", "false"});
  events.add(new String[] {"/pricing", "/landing", "75", "91", "true"});
  noLoop();
}

void draw() {
  background(15);
  fill(240);
  text("LaraVue visitor trend visualization sample", 24, 24);

  Map<String, Integer> routeCounts = new HashMap<String, Integer>();
  int totalDwell = 0;

  for (String[] e : events) {
    String route = e[0];
    int dwell = Integer.parseInt(e[2]);
    totalDwell += dwell;
    routeCounts.put(route, routeCounts.containsKey(route) ? routeCounts.get(route) + 1 : 1);
  }

  int y = 70;
  for (Map.Entry<String, Integer> entry : routeCounts.entrySet()) {
    text(entry.getKey() + " -> " + entry.getValue(), 24, y);
    y += 28;
  }

  text("Average dwell seconds: " + nf((float) totalDwell / events.size(), 1, 2), 24, y + 12);
  text("Use this sketch as a lightweight research view into a visitor log.", 24, y + 48);
}
