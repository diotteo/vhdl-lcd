/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "//sole.ens.ad.etsmtl.ca/ENS2/HOME/AK67270/ELE740/phase1/Phase 1/code/timer.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_0141943142_1678943863_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    int t12;
    int t13;
    int t14;
    int t15;

LAB0:    xsi_set_current_line(47, ng0);
    t1 = (t0 + 568U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 1884);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(50, ng0);
    t4 = (t0 + 684U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    if (t7 == 1)
        goto LAB8;

LAB9:    t4 = (t0 + 776U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)0);
    t3 = t10;

LAB10:    if (t3 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(57, ng0);
    t1 = (t0 + 1132U);
    t4 = *((char **)t1);
    t12 = *((int *)t4);
    t1 = (t0 + 868U);
    t5 = *((char **)t1);
    t13 = *((int *)t5);
    t2 = (t12 < t13);
    if (t2 != 0)
        goto LAB11;

LAB13:    xsi_set_current_line(60, ng0);
    t1 = (t0 + 1928);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 40U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)1;
    xsi_driver_first_trans_fast_port(t1);

LAB12:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(52, ng0);
    t4 = (t0 + 1132U);
    t11 = *((char **)t4);
    t4 = (t11 + 0);
    *((int *)t4) = 0;
    xsi_set_current_line(53, ng0);
    t1 = (t0 + 1928);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 40U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)0;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB6;

LAB8:    t3 = (unsigned char)1;
    goto LAB10;

LAB11:    xsi_set_current_line(58, ng0);
    t1 = (t0 + 1132U);
    t8 = *((char **)t1);
    t14 = *((int *)t8);
    t15 = (t14 + 1);
    t1 = (t0 + 1132U);
    t11 = *((char **)t1);
    t1 = (t11 + 0);
    *((int *)t1) = t15;
    goto LAB12;

}


extern void work_a_0141943142_1678943863_init()
{
	static char *pe[] = {(void *)work_a_0141943142_1678943863_p_0};
	xsi_register_didat("work_a_0141943142_1678943863", "isim/write_line_tb_isim_beh.exe.sim/work/a_0141943142_1678943863.didat");
	xsi_register_executes(pe);
}
