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
static const char *ng0 = "//sole.ens.ad.etsmtl.ca/ENS2/HOME/AK67270/ELE740/phase1/Phase 1/code/setddramaddress.vhd";
extern char *IEEE_P_2592010699;

char *ieee_p_2592010699_sub_1735675855_503743352(char *, char *, char *, char *, char *, char *);


static void work_a_1648352651_3573744473_p_0(char *t0)
{
    char t1[16];
    char t4[16];
    char t12[16];
    char t14[16];
    char *t2;
    char *t5;
    char *t6;
    int t7;
    unsigned int t8;
    char *t10;
    char *t11;
    char *t13;
    char *t15;
    char *t16;
    int t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned char t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;

LAB0:    xsi_set_current_line(50, ng0);

LAB3:    t2 = (t0 + 4074);
    t5 = (t4 + 0U);
    t6 = (t5 + 0U);
    *((int *)t6) = 0;
    t6 = (t5 + 4U);
    *((int *)t6) = 7;
    t6 = (t5 + 8U);
    *((int *)t6) = 1;
    t7 = (7 - 0);
    t8 = (t7 * 1);
    t8 = (t8 + 1);
    t6 = (t5 + 12U);
    *((unsigned int *)t6) = t8;
    t6 = (t0 + 4082);
    t10 = (t0 + 868U);
    t11 = *((char **)t10);
    t13 = ((IEEE_P_2592010699) + 2332);
    t15 = (t14 + 0U);
    t16 = (t15 + 0U);
    *((int *)t16) = 0;
    t16 = (t15 + 4U);
    *((int *)t16) = 0;
    t16 = (t15 + 8U);
    *((int *)t16) = 1;
    t17 = (0 - 0);
    t8 = (t17 * 1);
    t8 = (t8 + 1);
    t16 = (t15 + 12U);
    *((unsigned int *)t16) = t8;
    t16 = (t0 + 4016U);
    t10 = xsi_base_array_concat(t10, t12, t13, (char)97, t6, t14, (char)97, t11, t16, (char)101);
    t18 = ieee_p_2592010699_sub_1735675855_503743352(IEEE_P_2592010699, t1, t2, t4, t10, t12);
    t19 = (t1 + 12U);
    t8 = *((unsigned int *)t19);
    t20 = (1U * t8);
    t21 = (8U != t20);
    if (t21 == 1)
        goto LAB5;

LAB6:    t22 = (t0 + 2044);
    t23 = (t22 + 32U);
    t24 = *((char **)t23);
    t25 = (t24 + 40U);
    t26 = *((char **)t25);
    memcpy(t26, t18, 8U);
    xsi_driver_first_trans_fast(t22);

LAB2:    t27 = (t0 + 2000);
    *((int *)t27) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(8U, t20, 0);
    goto LAB6;

}


extern void work_a_1648352651_3573744473_init()
{
	static char *pe[] = {(void *)work_a_1648352651_3573744473_p_0};
	xsi_register_didat("work_a_1648352651_3573744473", "isim/write_line_tb_isim_beh.exe.sim/work/a_1648352651_3573744473.didat");
	xsi_register_executes(pe);
}
