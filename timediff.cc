#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void usage( ){
  cerr << "usage:" << endl;
  cerr << "timediff <file> [percentage]" << endl;
}

double getSecs( const string& line ){
  string::size_type bpos = line.find( ":" );
  if ( bpos != string::npos ){
    string::size_type epos = line.find( "(", bpos );
    if ( epos != string::npos ){
      string timeS = line.substr( bpos+1, epos - bpos - 1 );
      //      cerr << "time = " << timeS << endl;
      double result = atof( timeS.c_str() );
      return result;
    }
  }
  cerr << "no number extracted from '" << line << "'" << endl;
  exit(1);
  return -1;
}

int perc = 1;

int main( int argc, char **argv ){
  if ( argc < 2 ){
    usage();
  }
  if ( argc > 3 ){
    usage();
  }
  if ( argc == 3 ){
    perc = atoi( argv[2] );
  }
  ifstream is( argv[1] );
  string line;
  bool paired = true;
  double newSecs;
  double oldSecs;
  int testcase = 0;
  while ( getline( is, line ) ){
    //    cout << "line = " << line << endl;
    if ( line.empty() )
      continue;
    if ( line[0] == '<' ){
      if ( !paired ) {
	cerr << "problem: out of sync" << endl;
	exit(1);
      }
      paired = false;
      newSecs = getSecs( line );
    }
    else if ( line[0] == '>' ){
      if ( paired ) {
	cerr << "problem: out of sync" << endl;
	exit(1);
      }
      oldSecs = getSecs( line );
      paired = true;
    }
    if ( paired ){
      ++testcase;
      double diff = ( oldSecs - newSecs ) * 100 / oldSecs;
      if ( diff < -perc )
	cout << "testcase " << testcase << " worse  : " << diff << "%" << endl;
      else if ( diff > perc )
	cout << "testcase " << testcase << " better : " << diff << "%" << endl;
      else 
	cout << "testcase " << testcase << " within " << perc << "%" << endl;
    }
  }
}
