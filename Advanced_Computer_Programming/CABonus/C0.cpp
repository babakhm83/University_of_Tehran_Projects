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
#define MINUTESINHOUR 60

struct Time
{
	int hour;
	int minute;
};

struct Places
{
	string name;
	int rank;
	Time open_time;
	Time close_time;
	bool have_gone;
};

bool sort_by_rank(Places i, Places j)
{
	return i.rank < j.rank;
}

vector<string> seperate_words(const string line, string separate_char = ",")
{
	vector<string> words;
	string temp_line = line;
	size_t pos = 0;
	while ((pos = temp_line.find(separate_char)) != string::npos)
	{
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

struct Indexes
{
	int name;
	int rank;
	int opentime;
	int closetime;
};

Indexes extract_indexes_from_input(vector<string> title)
{
	Indexes indexes;
	indexes.name = find_position_of_data_in_input(title, NAME);
	indexes.rank = find_position_of_data_in_input(title, RANK);
	indexes.opentime = find_position_of_data_in_input(title, OPENINGTIME);
	indexes.closetime = find_position_of_data_in_input(title, CLOSINGTIME);
	return indexes;
}

Places extract_place_from_input(vector<string> words, string line)
{
	Places place;
	Indexes indexes = extract_indexes_from_input(seperate_words(line));
	place.name = words[indexes.name];
	place.rank = stoi(words[indexes.rank]);
	place.open_time.hour = stoi(words[indexes.opentime]);
	place.open_time.minute = stoi(words[indexes.opentime].substr(3));
	place.close_time.hour = stoi(words[indexes.closetime]);
	place.close_time.minute = stoi(words[indexes.closetime].substr(3));
	place.have_gone = false;
	return place;
}

vector<string> make_list_of_input_lines(char const *argv[])
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
	return lines;
}

vector<Places> extract_places_from_input(int argc, char const *argv[])
{
	vector<string> lines = make_list_of_input_lines(argv);
	vector<Places> Placess;
	for (int i = 1; i < lines.size(); i++)
	{
		vector<string> words_in_line = seperate_words(lines[i]);
		Placess.push_back(extract_place_from_input(words_in_line, lines[0]));
	}
	sort(Placess.begin(), Placess.end(), sort_by_rank);
	return Placess;
}

int remaining_time_this_place_is_open(Places place, Time now)
{
	return (place.close_time.hour - now.hour) * MINUTESINHOUR +
		   (place.close_time.minute - now.minute);
}

Time add_time(Time now, int added_minutes)
{
	if (added_minutes >= MINUTESINHOUR)
	{
		now.hour++;
		return now;
	}
	now.minute += added_minutes;
	if (now.minute >= MINUTESINHOUR)
	{
		now.hour++;
		now.minute -= MINUTESINHOUR;
	}
	return now;
}

bool is_this_place_open(Time t1, Time t2)
{
	if (t1.hour * MINUTESINHOUR + t1.minute >= t2.hour * MINUTESINHOUR + t2.minute)
		return true;
	return false;
}

int find_first_open_time(const vector<Places> Placess, Time start_time = {0, 0})
{
	int index = -1;
	int i;
	for (i = 0; i < Placess.size(); i++)
		if (is_this_place_open(Placess[i].open_time, start_time))
		{
			index = i;
			break;
		}
	for (int j = i + 1; j < Placess.size(); j++)
	{
		if ((Placess[j].open_time.hour < Placess[index].open_time.hour &&
			 is_this_place_open(Placess[j].open_time, start_time)) ||
			(Placess[j].open_time.hour == Placess[index].open_time.hour &&
			 Placess[j].open_time.minute < Placess[index].open_time.minute &&
			 is_this_place_open(Placess[j].open_time, start_time)))
		{

			index = j;
		}
	}
	return index;
}
int find_best_place_index(const vector<Places> Placess, const Time now)
{
	int index = -1;
	if (now.minute == -1)
	{
		index = find_first_open_time(Placess);
	}
	else
	{
		for (int i = 0; i < Placess.size(); i++)
		{
			if (!Placess[i].have_gone &&
				remaining_time_this_place_is_open(Placess[i], now) >= 15 &&
				is_this_place_open(now, Placess[i].open_time))
			{
				index = i;
				return index;
			}
		}
	}
	return index;
}

string time_to_string(Time t)
{
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

void print_Places(Places place, Time start_time, Time end_time)
{
	string start = time_to_string(start_time);
	string end = time_to_string(end_time);
	cout << "Location " << place.name << endl;
	cout << "Visit from " << start << " until " << end << endl;
	cout << "---" << endl;
}

Time skip_time(const vector<Places> Placess, Time now)
{
	int index = find_first_open_time(Placess, now);
	Time skiped_time = {-1, -1};
	if (index == -1)
		return skiped_time;
	else
	{
		skiped_time = Placess[index].open_time;
		return skiped_time;
	}
}

void where_to_go(vector<Places> Placess)
{
	Time now = {-1, -1};
	Time end_time;
	for (int i = 0; i < Placess.size(); i++)
	{
		int index = find_best_place_index(Placess, now);
		if (index == -1)
		{
			now = skip_time(Placess, add_time(now, 1));
			if (now.hour == -1)
				break;
			else
			{
				i = i - 1;
				continue;
			}
		}
		if (now.minute == -1)
		{
			now.hour = Placess[index].open_time.hour;
			now.minute = Placess[index].open_time.minute;
			end_time = add_time(now,
								remaining_time_this_place_is_open(Placess[index], now));
		}
		else
			end_time = add_time(now,
								remaining_time_this_place_is_open(Placess[index], now));
		Placess[index].have_gone = true;
		print_Places(Placess[index], now, end_time);
		now = add_time(end_time, 30);
	}
}

int main(int argc, char const *argv[])
{
	vector<Places> Placess = extract_places_from_input(argc, argv);
	where_to_go(Placess);
	return 0;
}