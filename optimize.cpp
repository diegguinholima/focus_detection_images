#include <iostream>
#include <vector>
#include <algorithm>

struct Sample{
    float value;
    bool focused;
};

int main( void ){

    int num_samples;
    float value;
    float threshold;
    std::vector<Sample> samples;

    std::cin >> num_samples;

    for(int i = 0; i < num_samples; i++){
        std::cin >> value;
        samples.push_back( {value, true } );
    }

    for(int i = 0; i < num_samples; i++){
        std::cin >> value;
        samples.push_back( {value, false } );
    }

    std::sort( samples.begin(),
               samples.end(),
               [](const Sample& s1, const Sample& s2) -> bool {
                   return s1.value < s2.value;
               });

    float best_threshold;
    int correct_choices;
    int best_correct_choice = 0;

    int i;
    for(i = 0; i < 2*num_samples - 1; i++){
        threshold = ( samples[i].value + samples[i+1].value ) / 2.0f;
        correct_choices = 0;

        for( Sample s : samples)
            if( ( (s.value > threshold) && s.focused ) || ( ( s.value <= threshold ) && !s.focused ) )
                correct_choices++;

        if(correct_choices > best_correct_choice){
            best_correct_choice = correct_choices;
            best_threshold = threshold;
        }
    }

    std::cout << best_threshold << ": " << best_correct_choice / 0.02f / num_samples << "% " << std::endl;

    return 0;
}
