#include "FTToStiffness.hpp"
#include <rtt/Component.hpp>
#include <iostream>

FTToStiffness::FTToStiffness(std::string const& name) : TaskContext(name){
    initializePorts();

    stiffness_max = 5000; // ToDo: come up with reasonable values
    stiffness_min = 10;
    //ft_max = 0.33;
    //ft_min = 0.029;
    max_rot_stiff = 300;
    _stiffness_counter= 0;
    alpha=0.010;


    std::ifstream fin("/home/kukalwr/git_repos/ManipubalityHRI/rtt-forceTrans-to-stiffness/ops-scripts/Ft_max.txt");
    fin >> ft_max;

    std::ifstream finp("/home/kukalwr/git_repos/ManipubalityHRI/rtt-forceTrans-to-stiffness/ops-scripts/Ft_min.txt");
    finp >> ft_min;

    addProperty("ft_factor",ft_factor).doc("The ft factor for chaning stiffness");
    addProperty("stiffness_max",stiffness_max).doc("Max Stiffness for the linear heuristic");
    addProperty("stiffness_min",stiffness_min).doc("Min Stiffness for the linear heuristic");
    addProperty("ft_max",ft_max).doc("Max ft expected");
    addProperty("ft_min",ft_min).doc("Min ft expected");


}



bool FTToStiffness::configureHook(){
    return true;
}

bool FTToStiffness::startHook(){
    return true;
}


// Apply differential stiffness limits are XYZ and ABC : TODO
void FTToStiffness::updateHook(){

    force_transmission_in_flow = force_transmission_in_port.read(force_transmission_in_data);

    if(force_transmission_in_data < ft_min){
        ft_factor = stiffness_min;
    }

    else if(force_transmission_in_data > ft_max){
        ft_factor = stiffness_max;
    }

    else if(force_transmission_in_data <= ft_max && force_transmission_in_data >= ft_min)
    {

        ft_factor = ((stiffness_max-stiffness_min)/(ft_max-ft_min))*(force_transmission_in_data-ft_min)+stiffness_min;

    }

    //std::cout<<" Stiffness: "<< manip_factor<<std::endl;


    /*// Filtering using lowpass filter
    _stiffness_vector_in.push_back(manip_factor);
    //_stiffness_vector_in(_stiffness_counter) = _stiffness;
    _a = (1-alpha)/(1+alpha);
    _b = (1-_a)/2;
    _xml= 0.9;
    if(_stiffness_counter==0)
        manip_factor = _stiffness_vector_in[_stiffness_counter]+_xml;
    else
        manip_factor = _b*_stiffness_vector_in[_stiffness_counter]+ _b*_stiffness_vector_in[_stiffness_counter-1]+ _a*_stiffness_vector_out[_stiffness_counter-1];

    _stiffness_vector_out.push_back(manip_factor);
    //_stiffness_vector_out(_stiffness_counter) = _filtered_stiffness;
    _stiffness_counter++;
*/




    for(int i = 0 ; i < 3 ; ++i){   // Setting stiffness for x,y,z
        cart_stiffdamp_out_data.stiffness(i) = ft_factor;

    }

    for(int i= 3; i < 6 ; ++i){

        cart_stiffdamp_out_data.stiffness(i) = ft_factor*(max_rot_stiff/stiffness_max);
    }
    //RTT::log(RTT::Critical) << ft_factor<< " :Stiffness  ]  ["<<force_transmission_in_data<<"  :FT]"<<RTT::endlog();

    // Filter these output later
    cart_stiffdamp_out_port.write(cart_stiffdamp_out_data);


}




void FTToStiffness::stopHook() {
}

void FTToStiffness::cleanupHook() {
}

void FTToStiffness::initializePorts(){

    /** OUTPUT PORTS    **/

    cart_stiffdamp_out_data = rstrt::dynamics::JointImpedance(6);
    cart_stiffdamp_out_port.setName("cart_stiffdamp_out_port");
    cart_stiffdamp_out_port.setDataSample(cart_stiffdamp_out_data);
    ports()->addPort(cart_stiffdamp_out_port);

    /** INPUT PORTS **/

    force_transmission_in_flow = RTT::NoData;
    force_transmission_in_port.setName("force_transmission_in_port");
    force_transmission_in_data = double();
    ports()->addPort(force_transmission_in_port);



}

/*
 * Using this macro, only one component may live
 * in one library *and* you may *not* link this library
 * with another component library. Use
 * ORO_CREATE_COMPONENT_TYPE()
 * ORO_LIST_COMPONENT_TYPE(ManipToStiffness)
 * In case you want to link with another library that
 * already contains components.
 *
 * If you have put your component class
 * in a namespace, don't forget to add it here too:
 */
ORO_CREATE_COMPONENT(FTToStiffness)
