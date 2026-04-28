#include <algorithm>
#include <chrono>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

struct VisitorEvent {
    std::string route;
    std::string referrer;
    double dwellSeconds;
    double scrollDepthPct;
    bool consent;
};

static std::vector<VisitorEvent> loadEvents(const std::string& path) {
    std::vector<VisitorEvent> events;
    std::ifstream file(path);
    if (!file.is_open()) {
        return events;
    }

    std::string line;
    while (std::getline(file, line)) {
        if (line.empty()) continue;

        std::stringstream ss(line);
        VisitorEvent event{};
        std::getline(ss, event.route, '\t');
        std::getline(ss, event.referrer, '\t');
        ss >> event.dwellSeconds;
        ss.ignore(1);
        ss >> event.scrollDepthPct;
        ss.ignore(1);
        int consent = 0;
        ss >> consent;
        event.consent = consent != 0;
        events.push_back(event);
    }

    return events;
}

static void printSummary(const std::vector<VisitorEvent>& events) {
    std::map<std::string, int> routeCounts;
    std::map<std::string, int> referrerCounts;
    double dwellTotal = 0.0;

    for (const auto& event : events) {
        routeCounts[event.route]++;
        referrerCounts[event.referrer.empty() ? "(direct)" : event.referrer]++;
        dwellTotal += event.dwellSeconds;
    }

    std::cout << "total_events=" << events.size() << "\n";
    std::cout << "average_dwell_seconds=" << (events.empty() ? 0.0 : dwellTotal / events.size()) << "\n";

    std::cout << "top_routes:\n";
    for (const auto& [route, count] : routeCounts) {
        std::cout << "  " << route << ": " << count << "\n";
    }

    std::cout << "top_referrers:\n";
    for (const auto& [referrer, count] : referrerCounts) {
        std::cout << "  " << referrer << ": " << count << "\n";
    }
}

int main(int argc, char** argv) {
    const std::string path = argc > 1 ? argv[1] : "events.tsv";
    auto events = loadEvents(path);

    if (events.empty()) {
        std::cout << "No events found. Create a TSV file with route, referrer, dwellSeconds, scrollDepthPct, consent.\n";
        return 0;
    }

    printSummary(events);
    return 0;
}
