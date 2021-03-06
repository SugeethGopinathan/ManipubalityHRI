#ifndef FTSTIFFNESS_HPP
#define FTSTIFFNESS_HPP

#include <rtt/RTT.hpp>
#include <rst-rt/kinematics/JointAngles.hpp>
#include <rst-rt/dynamics/JointTorques.hpp>
#include <kdl/frames.hpp>
#include <rst-rt/dynamics/JointImpedance.hpp>
#include <rst-rt/dynamics/Wrench.hpp>
#include <math.h>
#include <fstream>
#define DOF_SIZE 7

class FTToStiffness : public RTT::TaskContext{
public:
    FTToStiffness(std::string const& name);
    bool configureHook();
    bool startHook();
    void updateHook();
    void stopHook();
    void cleanupHook();


private:

    /** OUTPUT PORTS **/
    RTT::OutputPort<rstrt::dynamics::JointImpedance> cart_stiffdamp_out_port;
    rstrt::dynamics::JointImpedance                  cart_stiffdamp_out_data;


    /** INPUT PORTS **/

    RTT::InputPort<double>                      force_transmission_in_port;
    RTT::FlowStatus                             force_transmission_in_flow;
    double                                      force_transmission_in_data;



    void initializePorts();

    double ft_factor, ft_min, ft_max, stiffness_min, stiffness_max, max_rot_stiff;



    double _filtered_stiffness,alpha,_a,_b,_xml,_stiffness_counter;
    std::vector<double> _stiffness_vector_in,_stiffness_vector_out;
};
#endif
