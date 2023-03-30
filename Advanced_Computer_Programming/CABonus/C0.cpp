#include <iostream>
#include <sstream>
#include <fstream>
#include <algorithm>
#include <string>
#include <vector>
using namespace std;

struct Time {
	int hour;
	int minute;
};

struct Places {
	string name;
	int rank;
	Time open_time;
	Time close_time;
	bool have_gone;
};

bool sort_by_rank(Places i, Places j) {
	return i.rank < j.rank;
}

vector<string> seperateWords(const string line, string separate_char = ",") {
	vector<string> words;
	string temp = line;
	size_t pos = 0;
	while ((pos = temp.find(separate_char)) != string::npos) {
		words.push_back(temp.substr(0, pos));
		temp.erase(0, pos + separate_char.length());
	}
	words.push_back(temp);
	return words;
}

vector<Places> get_command_line(int argc, char const* argv[])
{
	ifstream instream;
	instream.open(argv[1]);
	if (instream.fail())
	{
		cout << "Input file opening failed.\n";
		exit(1);
	}
	vector<string> lines;
	string temp;
	while (getline(instream, temp))
		lines.push_back(temp);
	instream.close();
	vector<string> title = seperateWords(lines[0]);
	vector<Places> Placess;
	int name_index = distance(title.begin(), find(title.begin(), title.end(), "name"));
	int rank_index = distance(title.begin(), find(title.begin(), title.end(), "rank"));
	int opentime_index = distance(title.begin(), find(title.begin(), title.end(), "openingTime"));
	int closetime_index = distance(title.begin(), find(title.begin(), title.end(), "closingTime"));
	for (int i = 1; i < lines.size(); i++) {
		Places temp;
		vector<string> words_in_line = seperateWords(lines[i]);
		temp.name = words_in_line[name_index];
		temp.rank = stoi(words_in_line[rank_index]);
		temp.open_time.hour = stoi(words_in_line[opentime_index]);
		temp.open_time.minute = stoi(words_in_line[opentime_index].substr(3));
		temp.close_time.hour = stoi(words_in_line[closetime_index]);
		temp.close_time.minute = stoi(words_in_line[closetime_index].substr(3));
		temp.have_gone = false;
		Placess.push_back(temp);
	}
	sort(Placess.begin(), Placess.end(), sort_by_rank);
	return Placess;
}

int doringTime(Places plc, Time now) {
	return (plc.close_time.hour - now.hour) * 60 + (plc.close_time.minute - now.minute);
}

Time add_time(Time now, int doringTime) {
	if (doringTime >= 60) {
		now.hour += 1;
		return now;
	}
	now.minute += doringTime;
	if (now.minute >= 60) {
		now.hour++;
		now.minute -= 60;
	}
	return now;
}

bool is_time_grater(Time t1, Time t2) {
	if (t1.hour * 60 + t1.minute >= t2.hour * 60 + t2.minute)
		return true;
	return false;
}

int find_first_open_time(const vector<Places> Placess, Time start_time = { 0,0 })
{
	int index = -1;
	int i;
	for (i = 0; i < Placess.size(); i++)
		if (is_time_grater(Placess[i].open_time, start_time)) {
			index = i;
			break;
		}
	for (int j = i + 1; j < Placess.size(); j++) {
		if (Placess[j].open_time.hour < Placess[index].open_time.hour && is_time_grater(Placess[j].open_time, start_time)) {
			index = j;
			continue;
		}
		if (Placess[j].open_time.hour == Placess[index].open_time.hour && Placess[j].open_time.minute < Placess[index].open_time.minute && is_time_grater(Placess[j].open_time, start_time))
			index = j;
	}
	return index;
}

int find_best_plce_index(const vector<Places> Placess, const Time now) {
	int index = -1;
	if (now.minute == -1) {
		index = find_first_open_time(Placess);
	}
	else {
		for ( int i = 0; i < Placess.size(); i++) {
			if (!Placess[i].have_gone && doringTime(Placess[i], now) >= 15 && is_time_grater(now, Placess[i].open_time)) {
				index = i;
				return index;
			}
		}
	}
	return index;
}





string time2string(Time t) {
	string str;
	if (t.hour < 10)
		str += "0" + to_string(t.hour);
	else
		str += to_string(t.hour);
	str += ":";
	if (t.minute < 10)
		str += "0" + to_string(t.minute);
	else
		str += to_string(t.minute);
	return str;
}

void print_Places(Places plc, Time start_time, Time end_time) {
	string start = time2string(start_time);
	string end = time2string(end_time);
	cout << "Location " << plc.name << endl;
	cout << "Visit from " << start << " until " << end << endl;
	cout << "---" << endl;
}

Time skip_time(const vector<Places> Placess, Time now)
{
	int index = find_first_open_time(Placess, now);
	Time skiped_time = { -1,-1 };
	if ( index == -1)
		return skiped_time;
	else {
		skiped_time = Placess[index].open_time;
		return skiped_time;
	}
}

void WhereToGo(vector<Places> Placess) {
	Time now = { -1,-1 };
	Time end_time;
	for (int i = 0; i < Placess.size(); i++) {
		int index = find_best_plce_index(Placess, now);
		if ( index == -1) {
			now = skip_time(Placess, add_time(now, 1));
			if (now.hour == -1)
				break;
			else {
				i = i - 1;
				continue;
			}
		}
		if ( now.minute == -1) {
			now.hour = Placess[index].open_time.hour;
			now.minute = Placess[index].open_time.minute;
			end_time = add_time(now, doringTime(Placess[index], now));
		}
		else
			end_time = add_time(now, doringTime(Placess[index], now));
		Placess[index].have_gone = true;
		print_Places(Placess[index], now, end_time);
		now = add_time(end_time, 30);
	}
}

int main(int argc, char const* argv[])
{
	vector<Places> Placess = get_command_line(argc, argv);
	WhereToGo(Placess);
	return 0;
}