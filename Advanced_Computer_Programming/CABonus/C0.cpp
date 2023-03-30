#include <iostream>
#include <sstream>
#include <fstream>
#include <algorithm>
#include <string>
#include <vector>
using namespace std;

#define NAME "name"
#define RANK "rank"
#define OPENINGTIME "openingTime"
#define CLOSINGTIME "closingTime"

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
	string temp_line = line;
	size_t pos = 0;
	while ((pos = temp_line.find(separate_char)) != string::npos) {
		words.push_back(temp_line.substr(0, pos));
		temp_line.erase(0, pos + separate_char.length());
	}
	words.push_back(temp_line);
	return words;
}

int find_position_of_data_in_input(vector<string> input, string data)
{
	return distance(input.begin(), find(input.begin(), input.end(), data));
}

struct Indexes{
	int name;
	int rank;
	int opentime;
	int closetime;
};

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
	string temp_line;
	while (getline(instream, temp_line))
		lines.push_back(temp_line);
	instream.close();
	vector<string> title = seperateWords(lines[0]);
	vector<Places> Placess;
	Indexes indexes;
	indexes.name = find_position_of_data_in_input(title, NAME);
	indexes.rank = find_position_of_data_in_input(title, RANK);
	indexes.opentime = find_position_of_data_in_input(title, OPENINGTIME);
	indexes.closetime = find_position_of_data_in_input(title, CLOSINGTIME);
	for (int i = 1; i < lines.size(); i++) {
		Places temp_place;
		vector<string> words_in_line = seperateWords(lines[i]);
		temp_place.name = words_in_line[indexes.name];
		temp_place.rank = stoi(words_in_line[indexes.rank]);
		temp_place.open_time.hour = stoi(words_in_line[indexes.opentime]);
		temp_place.open_time.minute = stoi(words_in_line[indexes.opentime].substr(3));
		temp_place.close_time.hour = stoi(words_in_line[indexes.closetime]);
		temp_place.close_time.minute = stoi(words_in_line[indexes.closetime].substr(3));
		temp_place.have_gone = false;
		Placess.push_back(temp_place);
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