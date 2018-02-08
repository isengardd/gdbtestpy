#include <set>

void AddMapData(std::set<int*>& dataMap, int* iVal){
	dataMap.insert(iVal);
}

void DeleteMapData(std::set<int*>& dataMap, int* iVal){
	dataMap.erase(iVal);
}

int main(){
	std::set<int*> dataMap;
	
	int *p1 = new int(1);
	int *p2 = new int(2);
	AddMapData(dataMap, p1);
	AddMapData(dataMap, p2);

	*p2 = 10;	
	delete p2;

	DeleteMapData(dataMap, p1);
	DeleteMapData(dataMap, p2);

	delete p1;
	delete p2;
	return 0;
}
