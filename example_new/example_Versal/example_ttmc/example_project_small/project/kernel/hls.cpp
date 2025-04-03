
//===----------------------------------------------------------------------===//
//
// Automatically generated file for hlc.cpp
//
//===----------------------------------------------------------------------===//
#include <math.h>
#include <stdint.h>
#include <ap_int.h>
#include <ap_fixed.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>
#include <hls_math.h>
void send3_0(
  hls::stream< ap_int<128> > &v48 /* v48[1] */,
  ap_int<128> v49[2][16][8],
  bool v50
){
  #pragma HLS inline OFF
  if (v50) {	// L192
    for (int v51 = 0; v51 < 1; v51++) {	// L193
      for (int v52 = 0; v52 < 2; v52++) {	// L194
        for (int v53 = 0; v53 < 2; v53++) {	// L195
          for (int v54 = 0; v54 < 8; v54++) {	// L196
            for (int v55 = 0; v55 < 1; v55++) {	// L197
              for (int v56 = 0; v56 < 8; v56++) {	// L198
              #pragma HLS pipeline II=1
                ap_int<128> v57 = v48.read(); //v48                v57 = v48;	// L199
                v49[(v53 + (v51 * 2))][(v54 + (v52 * 8))][(v56 + (v55 * 8))] = v57;	// L200
              }
            }
          }
        }
      }
    }
  }
}

void send3_1(
  ap_int<128> v58[2][16][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v59 /* v59[1] */,
  bool v60
){
  #pragma HLS inline OFF
  if (v60) {	// L211
    for (int v61 = 0; v61 < 1; v61++) {	// L212
      for (int v62 = 0; v62 < 2; v62++) {	// L213
        for (int v63 = 0; v63 < 2; v63++) {	// L214
          for (int v64 = 0; v64 < 2; v64++) {	// L215
            for (int v65 = 0; v65 < 1; v65++) {	// L216
              for (int v66 = 0; v66 < 2; v66++) {	// L217
                for (int v67 = 0; v67 < 8; v67++) {	// L218
                  for (int v68 = 0; v68 < 8; v68++) {	// L219
                  #pragma HLS pipeline II=1
                    ap_int<128> v69 = v58[(v66 + (v61 * 2))][(v67 + (v64 * 8))][(v68 + (v65 * 8))];	// L220
                    ap_axiu<128, 0 ,0 ,0> v59_axiu;
                    v59_axiu.data = v69;
                    v59_axiu.keep = -1;
                    v59.write(v59_axiu); //v59                    v59 = v69;	// L221
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send3(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v70 /* v70[1] */,
  hls::stream< ap_int<128> > &v71 /* v71[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v72[2][16][8];	// L238
  #pragma HLS bind_storage variable=v72 type=ram_t2p impl=uram
  ap_int<128> v73[2][16][8];	// L239
  #pragma HLS bind_storage variable=v73 type=ram_t2p impl=uram
  for (int v74 = 0; v74 < 1; v74++) {	// L240
    for (int v75 = 0; v75 < 1; v75++) {	// L241
      for (int v76 = 0; v76 < 1; v76++) {	// L242
        for (int v77 = 0; v77 < 2; v77++) {	// L243
          for (int v78 = 0; v78 < 2; v78++) {	// L244
            int v79 = v77 * 2;	// L245
            int v80 = v78 + v79;	// L246
            int v81 = v76 * 4;	// L247
            int v82 = v80 + v81;	// L248
            int v83 = v75 * 4;	// L249
            int v84 = v82 + v83;	// L250
            int v85 = v74 * 4;	// L251
            int v86 = v84 + v85;	// L252
            int v87 = v86 % 2;	// L253
            bool v88 = v87 == 0;	// L254
            bool v89 = v86 != 0;	// L255
            if (v88) {	// L256
              send3_0(v71, v72, 1);	// L257
              send3_1(v73, v70, v89);	// L258
            } else {
              send3_0(v71, v73, 1);	// L260
              send3_1(v72, v70, v89);	// L261
            }
          }
        }
      }
    }
  }
  send3_1(v73, v70, 1);	// L268
}

void send3_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v90 /* v90[1] */,
  hls::stream< ap_int<128> > &v91 /* v91[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v92 /* v92[1] */,
  hls::stream< ap_int<128> > &v93 /* v93[1] */
){
  #pragma HLS inline OFF
  send3<0>(v90, v91);	// L272
  send3<1>(v92, v93);	// L273
}

template<int NC>
void load2(
  ap_int<512> v94[128][4],
  hls::stream< ap_int<512> > &v95 /* v95[1] */,
  hls::stream< ap_int<512> > &v96 /* v96[1] */,
  hls::stream< ap_int<512> > &v97 /* v97[1] */,
  hls::stream< ap_int<512> > &v98 /* v98[1] */
){
  #pragma HLS inline OFF
  for (int v99 = 0; v99 < 1; v99++) {	// L278
    for (int v100 = 0; v100 < 1; v100++) {	// L279
      for (int v101 = 0; v101 < 1; v101++) {	// L280
        for (int v102 = 0; v102 < 2; v102++) {	// L281
          for (int v103 = 0; v103 < 2; v103++) {	// L282
            for (int v104 = 0; v104 < 1; v104++) {	// L283
              for (int v105 = 0; v105 < 32; v105++) {	// L284
                for (int v106 = 0; v106 < 2; v106++) {	// L285
                  for (int v107 = 0; v107 < 2; v107++) {	// L286
                  #pragma HLS pipeline II=1
                    ap_int<512> v108 = v94[((v105 + (v104 * 64)) + (v103 * 64))][((v107 + (v106 * 2)) + (v101 * 4))];	// L287
                    bool v109 = v107 < 1;	// L288
                    if (v109) {	// L289
                      v98.write(v108); //v98                      v98 = v108;	// L290
                    } else {
                      v96.write(v108); //v96                      v96 = v108;	// L292
                    }
                  }
                }
              }
            }
            for (int v110 = 0; v110 < 1; v110++) {	// L298
              for (int v111 = 0; v111 < 32; v111++) {	// L299
                for (int v112 = 0; v112 < 2; v112++) {	// L300
                  for (int v113 = 0; v113 < 2; v113++) {	// L301
                  #pragma HLS pipeline II=1
                    ap_int<512> v114 = v94[(((v111 + (v110 * 64)) + (v103 * 64)) + 32)][((v113 + (v112 * 2)) + (v101 * 4))];	// L302
                    bool v115 = v113 < 1;	// L303
                    if (v115) {	// L304
                      v97.write(v114); //v97                      v97 = v114;	// L305
                    } else {
                      v95.write(v114); //v95                      v95 = v114;	// L307
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load2_top(
  ap_int<512> v116[128][4],
  hls::stream< ap_int<512> > &v117 /* v117[1] */,
  hls::stream< ap_int<512> > &v118 /* v118[1] */,
  hls::stream< ap_int<512> > &v119 /* v119[1] */,
  hls::stream< ap_int<512> > &v120 /* v120[1] */
){
  #pragma HLS inline OFF
  load2<0>(v116, v117, v118, v119, v120);	// L321
}

template<int NC>
void load2_3(
  hls::stream< ap_int<128> > &v121 /* v121[1] */,
  hls::stream< ap_int<512> > &v122 /* v122[1] */
){
  #pragma HLS inline OFF
  for (int v123 = 0; v123 < 1; v123++) {	// L325
    for (int v124 = 0; v124 < 1; v124++) {	// L326
      for (int v125 = 0; v125 < 1; v125++) {	// L327
        for (int v126 = 0; v126 < 2; v126++) {	// L328
          for (int v127 = 0; v127 < 2; v127++) {	// L329
            for (int v128 = 0; v128 < 1; v128++) {	// L330
              for (int v129 = 0; v129 < 32; v129++) {	// L331
                for (int v130 = 0; v130 < 2; v130++) {	// L332
                  for (int v131 = 0; v131 < 1; v131++) {	// L333
                  #pragma HLS pipeline II=4
                    ap_int<512> v132 = v122.read(); //v122                    v132 = v122;	// L334
                    for (int v133 = 0; v133 < 4; v133++) {	// L335
                    #pragma HLS pipeline II=1
                      int v134 = ((v133 * 128) + 127);	// L336
                      int v135 = (v133 * 128);	// L337
                      ap_int<128> v136 = v132(v134, v135);	// L338
                      v121.write(v136); //v121                      v121 = v136;	// L339
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load2_3_top(
  hls::stream< ap_int<128> > &v137 /* v137[1] */,
  hls::stream< ap_int<512> > &v138 /* v138[1] */,
  hls::stream< ap_int<128> > &v139 /* v139[1] */,
  hls::stream< ap_int<512> > &v140 /* v140[1] */,
  hls::stream< ap_int<128> > &v141 /* v141[1] */,
  hls::stream< ap_int<512> > &v142 /* v142[1] */,
  hls::stream< ap_int<128> > &v143 /* v143[1] */,
  hls::stream< ap_int<512> > &v144 /* v144[1] */
){
  #pragma HLS inline OFF
  load2_3<0>(v137, v138);	// L353
  load2_3<1>(v139, v140);	// L354
  load2_3<2>(v141, v142);	// L355
  load2_3<3>(v143, v144);	// L356
}

void send5_0(
  hls::stream< ap_int<128> > &v145 /* v145[1] */,
  ap_int<128> v146[32][8],
  bool v147
){
  #pragma HLS inline OFF
  if (v147) {	// L360
    for (int v148 = 0; v148 < 1; v148++) {	// L361
      for (int v149 = 0; v149 < 32; v149++) {	// L362
        for (int v150 = 0; v150 < 2; v150++) {	// L363
          for (int v151 = 0; v151 < 4; v151++) {	// L364
          #pragma HLS pipeline II=1
            ap_int<128> v152 = v145.read(); //v145            v152 = v145;	// L365
            v146[(v149 + (v148 * 32))][(v151 + (v150 * 4))] = v152;	// L366
          }
        }
      }
    }
  }
}

void send5_1(
  ap_int<128> v153[32][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v154 /* v154[1] */,
  bool v155
){
  #pragma HLS inline OFF
  if (v155) {	// L375
    for (int v156 = 0; v156 < 1; v156++) {	// L376
      for (int v157 = 0; v157 < 2; v157++) {	// L377
        for (int v158 = 0; v158 < 2; v158++) {	// L378
          for (int v159 = 0; v159 < 2; v159++) {	// L379
            for (int v160 = 0; v160 < 1; v160++) {	// L380
              for (int v161 = 0; v161 < 32; v161++) {	// L381
                for (int v162 = 0; v162 < 4; v162++) {	// L382
                #pragma HLS pipeline II=1
                  ap_int<128> v163 = v153[(v161 + (v160 * 32))][(v162 + (v158 * 4))];	// L383
                  ap_axiu<128, 0 ,0 ,0> v154_axiu;
                  v154_axiu.data = v163;
                  v154_axiu.keep = -1;
                  v154.write(v154_axiu); //v154                  v154 = v163;	// L384
                }
              }
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send5(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v164 /* v164[1] */,
  hls::stream< ap_int<128> > &v165 /* v165[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v166[32][8];	// L400
  #pragma HLS bind_storage variable=v166 type=ram_t2p impl=uram
  ap_int<128> v167[32][8];	// L401
  #pragma HLS bind_storage variable=v167 type=ram_t2p impl=uram
  for (int v168 = 0; v168 < 1; v168++) {	// L402
    for (int v169 = 0; v169 < 1; v169++) {	// L403
      for (int v170 = 0; v170 < 1; v170++) {	// L404
        for (int v171 = 0; v171 < 2; v171++) {	// L405
          for (int v172 = 0; v172 < 2; v172++) {	// L406
            int v173 = v171 * 2;	// L407
            int v174 = v172 + v173;	// L408
            int v175 = v170 * 4;	// L409
            int v176 = v174 + v175;	// L410
            int v177 = v169 * 4;	// L411
            int v178 = v176 + v177;	// L412
            int v179 = v168 * 4;	// L413
            int v180 = v178 + v179;	// L414
            int v181 = v180 % 2;	// L415
            bool v182 = v181 == 0;	// L416
            bool v183 = v180 != 0;	// L417
            if (v182) {	// L418
              send5_0(v165, v166, 1);	// L419
              send5_1(v167, v164, v183);	// L420
            } else {
              send5_0(v165, v167, 1);	// L422
              send5_1(v166, v164, v183);	// L423
            }
          }
        }
      }
    }
  }
  send5_1(v167, v164, 1);	// L430
}

void send5_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v184 /* v184[1] */,
  hls::stream< ap_int<128> > &v185 /* v185[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v186 /* v186[1] */,
  hls::stream< ap_int<128> > &v187 /* v187[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v188 /* v188[1] */,
  hls::stream< ap_int<128> > &v189 /* v189[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v190 /* v190[1] */,
  hls::stream< ap_int<128> > &v191 /* v191[1] */
){
  #pragma HLS inline OFF
  send5<0>(v184, v185);	// L434
  send5<1>(v186, v187);	// L435
  send5<2>(v188, v189);	// L436
  send5<3>(v190, v191);	// L437
}

void send1_0(
  hls::stream< ap_int<128> > &v192 /* v192[1] */,
  ap_int<128> v193[16][8],
  bool v194
){
  #pragma HLS inline OFF
  if (v194) {	// L441
    for (int v195 = 0; v195 < 2; v195++) {	// L442
      for (int v196 = 0; v196 < 8; v196++) {	// L443
        for (int v197 = 0; v197 < 2; v197++) {	// L444
          for (int v198 = 0; v198 < 4; v198++) {	// L445
          #pragma HLS pipeline II=1
            ap_int<128> v199 = v192.read(); //v192            v199 = v192;	// L446
            v193[(v196 + (v195 * 8))][(v198 + (v197 * 4))] = v199;	// L447
          }
        }
      }
    }
  }
}

void send1_1(
  ap_int<128> v200[16][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v201 /* v201[1] */,
  bool v202
){
  #pragma HLS inline OFF
  if (v202) {	// L456
    for (int v203 = 0; v203 < 1; v203++) {	// L457
      for (int v204 = 0; v204 < 2; v204++) {	// L458
        for (int v205 = 0; v205 < 2; v205++) {	// L459
          for (int v206 = 0; v206 < 2; v206++) {	// L460
            for (int v207 = 0; v207 < 1; v207++) {	// L461
              for (int v208 = 0; v208 < 8; v208++) {	// L462
                for (int v209 = 0; v209 < 4; v209++) {	// L463
                #pragma HLS pipeline II=1
                  ap_int<128> v210 = v200[(v208 + (v206 * 8))][(v209 + (v204 * 4))];	// L464
                  ap_axiu<128, 0 ,0 ,0> v201_axiu;
                  v201_axiu.data = v210;
                  v201_axiu.keep = -1;
                  v201.write(v201_axiu); //v201                  v201 = v210;	// L465
                }
              }
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send1(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v211 /* v211[1] */,
  hls::stream< ap_int<128> > &v212 /* v212[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v213[16][8];	// L481
  #pragma HLS bind_storage variable=v213 type=ram_s2p impl=bram
  ap_int<128> v214[16][8];	// L482
  #pragma HLS bind_storage variable=v214 type=ram_s2p impl=bram
  for (int v215 = 0; v215 < 1; v215++) {	// L483
    for (int v216 = 0; v216 < 1; v216++) {	// L484
      for (int v217 = 0; v217 < 1; v217++) {	// L485
        for (int v218 = 0; v218 < 2; v218++) {	// L486
          for (int v219 = 0; v219 < 2; v219++) {	// L487
            int v220 = v218 * 2;	// L488
            int v221 = v219 + v220;	// L489
            int v222 = v217 * 4;	// L490
            int v223 = v221 + v222;	// L491
            int v224 = v216 * 4;	// L492
            int v225 = v223 + v224;	// L493
            int v226 = v215 * 4;	// L494
            int v227 = v225 + v226;	// L495
            int v228 = v227 % 2;	// L496
            bool v229 = v228 == 0;	// L497
            bool v230 = v227 != 0;	// L498
            if (v229) {	// L499
              send1_0(v212, v213, 1);	// L500
              send1_1(v214, v211, v230);	// L501
            } else {
              send1_0(v212, v214, 1);	// L503
              send1_1(v213, v211, v230);	// L504
            }
          }
        }
      }
    }
  }
  send1_1(v214, v211, 1);	// L511
}

void send1_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v231 /* v231[1] */,
  hls::stream< ap_int<128> > &v232 /* v232[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v233 /* v233[1] */,
  hls::stream< ap_int<128> > &v234 /* v234[1] */
){
  #pragma HLS inline OFF
  send1<0>(v231, v232);	// L515
  send1<1>(v233, v234);	// L516
}

template<int NC>
void receive2(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v235 /* v235[1] */,
  hls::stream< ap_int<128> > &v236 /* v236[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v237[2][32][8];	// L529
  #pragma HLS bind_storage variable=v237 type=ram_s2p impl=bram
  for (int v238 = 0; v238 < 2; v238++) {	// L530
    for (int v239 = 0; v239 < 32; v239++) {	// L531
      for (int v240 = 0; v240 < 8; v240++) {	// L532
      #pragma HLS pipeline II=1
        v237[v238][v239][v240] = 0;	// L533
      }
    }
  }
  for (int v241 = 0; v241 < 1; v241++) {	// L537
    for (int v242 = 0; v242 < 1; v242++) {	// L538
      for (int v243 = 0; v243 < 1; v243++) {	// L539
        for (int v244 = 0; v244 < 2; v244++) {	// L540
          for (int v245 = 0; v245 < 2; v245++) {	// L541
            for (int v246 = 0; v246 < 1; v246++) {	// L542
              for (int v247 = 0; v247 < 2; v247++) {	// L543
                for (int v248 = 0; v248 < 2; v248++) {	// L544
                  for (int v249 = 0; v249 < 2; v249++) {	// L545
                    for (int v250 = 0; v250 < 1; v250++) {	// L546
                      for (int v251 = 0; v251 < 2; v251++) {	// L547
                        for (int v252 = 0; v252 < 16; v252++) {	// L548
                          for (int v253 = 0; v253 < 4; v253++) {	// L549
                          #pragma HLS pipeline II=1
                            ap_axiu<128, 0 ,0 ,0> v235_axiu = v235.read();
                            ap_int<128> v254 = v235_axiu.data; //v235                            v254 = v235;	// L550
                            ap_int<128> v255 = v237[(v251 + (v246 * 2))][(v252 + (v247 * 16))][(v253 + (v248 * 4))];	// L551
                            ap_int<128> v256 = v254;
                            ap_int<128> v257 = v255;
                            ap_int<128> v258 = 0;
                            int32_t v259 = v256(31, 0);	// L555
                            int32_t v260 = v257(31, 0);	// L556
                            int32_t v261 = v259 + v260;	// L557
                            v258(31, 0) = v261;	// L558
                            int32_t v262 = v256(63, 32);	// L559
                            int32_t v263 = v257(63, 32);	// L560
                            int32_t v264 = v262 + v263;	// L561
                            v258(63, 32) = v264;	// L562
                            int32_t v265 = v256(95, 64);	// L563
                            int32_t v266 = v257(95, 64);	// L564
                            int32_t v267 = v265 + v266;	// L565
                            v258(95, 64) = v267;	// L566
                            int32_t v268 = v256(127, 96);	// L567
                            int32_t v269 = v257(127, 96);	// L568
                            int32_t v270 = v268 + v269;	// L569
                            v258(127, 96) = v270;	// L570
                            ap_int<128> v271 = v258;
                            v237[(v251 + (v246 * 2))][(v252 + (v247 * 16))][(v253 + (v248 * 4))] = v271;	// L572
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        for (int v272 = 0; v272 < 1; v272++) {	// L583
          for (int v273 = 0; v273 < 2; v273++) {	// L584
            for (int v274 = 0; v274 < 2; v274++) {	// L585
              for (int v275 = 0; v275 < 16; v275++) {	// L586
                for (int v276 = 0; v276 < 2; v276++) {	// L587
                  for (int v277 = 0; v277 < 4; v277++) {	// L588
                  #pragma HLS pipeline II=1
                    ap_int<128> v278 = v237[(v274 + (v272 * 2))][(v275 + (v273 * 16))][(v277 + (v276 * 4))];	// L589
                    v236.write(v278); //v236                    v236 = v278;	// L590
                    v237[(v274 + (v272 * 2))][(v275 + (v273 * 16))][(v277 + (v276 * 4))] = 0;	// L591
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void receive2_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v279 /* v279[1] */,
  hls::stream< ap_int<128> > &v280 /* v280[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v281 /* v281[1] */,
  hls::stream< ap_int<128> > &v282 /* v282[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v283 /* v283[1] */,
  hls::stream< ap_int<128> > &v284 /* v284[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v285 /* v285[1] */,
  hls::stream< ap_int<128> > &v286 /* v286[1] */
){
  #pragma HLS inline OFF
  receive2<0>(v279, v280);	// L604
  receive2<1>(v281, v282);	// L605
  receive2<2>(v283, v284);	// L606
  receive2<3>(v285, v286);	// L607
}

template<int NC>
void store0_0(
  hls::stream< ap_int<128> > &v287 /* v287[1] */,
  hls::stream< ap_int<512> > &v288 /* v288[1] */
){
  #pragma HLS inline OFF
  for (int v289 = 0; v289 < 1; v289++) {	// L612
    for (int v290 = 0; v290 < 1; v290++) {	// L613
      for (int v291 = 0; v291 < 1; v291++) {	// L614
        for (int v292 = 0; v292 < 1; v292++) {	// L615
          for (int v293 = 0; v293 < 2; v293++) {	// L616
            for (int v294 = 0; v294 < 2; v294++) {	// L617
              for (int v295 = 0; v295 < 16; v295++) {	// L618
                for (int v296 = 0; v296 < 2; v296++) {	// L619
                  for (int v297 = 0; v297 < 1; v297++) {	// L620
                  #pragma HLS pipeline II=4
                    ap_int<512> v298 = 0;
                    for (int v299 = 0; v299 < 4; v299++) {	// L622
                    #pragma HLS pipeline II=1
                      ap_int<128> v300 = v287.read(); //v287                      v300 = v287;	// L623
                      int v301 = ((v299 * 128) + 127);	// L624
                      int v302 = (v299 * 128);	// L625
                      v298(v301, v302) = v300;	// L626
                    }
                    v288.write(v298); //v288                    v288 = v298;	// L628
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void store0_0_top(
  hls::stream< ap_int<128> > &v303 /* v303[1] */,
  hls::stream< ap_int<512> > &v304 /* v304[1] */,
  hls::stream< ap_int<128> > &v305 /* v305[1] */,
  hls::stream< ap_int<512> > &v306 /* v306[1] */,
  hls::stream< ap_int<128> > &v307 /* v307[1] */,
  hls::stream< ap_int<512> > &v308 /* v308[1] */,
  hls::stream< ap_int<128> > &v309 /* v309[1] */,
  hls::stream< ap_int<512> > &v310 /* v310[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v303, v304);	// L641
  store0_0<1>(v305, v306);	// L642
  store0_0<2>(v307, v308);	// L643
  store0_0<3>(v309, v310);	// L644
}

template<int NC>
void store0(
  ap_int<512> v311[2][64][4],
  hls::stream< ap_int<512> > &v312 /* v312[1] */,
  hls::stream< ap_int<512> > &v313 /* v313[1] */,
  hls::stream< ap_int<512> > &v314 /* v314[1] */,
  hls::stream< ap_int<512> > &v315 /* v315[1] */
){
  #pragma HLS inline OFF
  for (int v316 = 0; v316 < 1; v316++) {	// L649
    for (int v317 = 0; v317 < 1; v317++) {	// L650
      for (int v318 = 0; v318 < 1; v318++) {	// L651
        for (int v319 = 0; v319 < 1; v319++) {	// L652
          for (int v320 = 0; v320 < 2; v320++) {	// L653
            for (int v321 = 0; v321 < 2; v321++) {	// L654
              for (int v322 = 0; v322 < 16; v322++) {	// L655
                for (int v323 = 0; v323 < 2; v323++) {	// L656
                  for (int v324 = 0; v324 < 2; v324++) {	// L657
                  #pragma HLS pipeline II=1
                    bool v325 = v324 < 1;	// L658
                    ap_int<512> v326;
                    if (v325) {	// L659
                      ap_int<512> v327 = v315.read(); //v315                      v327 = v315;	// L660
                      v326 = v327;	// L661
                    } else {
                      ap_int<512> v328 = v314.read(); //v314                      v328 = v314;	// L663
                      v326 = v328;	// L664
                    }
                    v311[((v321 + (v316 * 2)) + (v319 * 2))][((v322 + (v320 * 32)) + (v317 * 64))][((v324 + (v323 * 2)) + (v318 * 4))] = v326;	// L666
                  }
                }
              }
            }
          }
        }
        for (int v329 = 0; v329 < 1; v329++) {	// L673
          for (int v330 = 0; v330 < 2; v330++) {	// L674
            for (int v331 = 0; v331 < 2; v331++) {	// L675
              for (int v332 = 0; v332 < 16; v332++) {	// L676
                for (int v333 = 0; v333 < 2; v333++) {	// L677
                  for (int v334 = 0; v334 < 2; v334++) {	// L678
                  #pragma HLS pipeline II=1
                    bool v335 = v334 < 1;	// L679
                    ap_int<512> v336;
                    if (v335) {	// L680
                      ap_int<512> v337 = v313.read(); //v313                      v337 = v313;	// L681
                      v336 = v337;	// L682
                    } else {
                      ap_int<512> v338 = v312.read(); //v312                      v338 = v312;	// L684
                      v336 = v338;	// L685
                    }
                    v311[((v331 + (v316 * 2)) + (v329 * 2))][(((v332 + (v330 * 32)) + (v317 * 64)) + 16)][((v334 + (v333 * 2)) + (v318 * 4))] = v336;	// L687
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void store0_top(
  ap_int<512> v339[2][64][4],
  hls::stream< ap_int<512> > &v340 /* v340[1] */,
  hls::stream< ap_int<512> > &v341 /* v341[1] */,
  hls::stream< ap_int<512> > &v342 /* v342[1] */,
  hls::stream< ap_int<512> > &v343 /* v343[1] */
){
  #pragma HLS inline OFF
  store0<0>(v339, v340, v341, v342, v343);	// L700
}

template<int NC>
void load0(
  ap_int<512> v344[2][32][8],
  hls::stream< ap_int<512> > &v345 /* v345[1] */,
  hls::stream< ap_int<512> > &v346 /* v346[1] */
){
  #pragma HLS inline OFF
  for (int v347 = 0; v347 < 1; v347++) {	// L705
    for (int v348 = 0; v348 < 1; v348++) {	// L706
      for (int v349 = 0; v349 < 1; v349++) {	// L707
        for (int v350 = 0; v350 < 2; v350++) {	// L708
          for (int v351 = 0; v351 < 2; v351++) {	// L709
            for (int v352 = 0; v352 < 1; v352++) {	// L710
              for (int v353 = 0; v353 < 2; v353++) {	// L711
                for (int v354 = 0; v354 < 2; v354++) {	// L712
                  for (int v355 = 0; v355 < 8; v355++) {	// L713
                    for (int v356 = 0; v356 < 1; v356++) {	// L714
                      for (int v357 = 0; v357 < 4; v357++) {	// L715
                      #pragma HLS pipeline II=1
                        ap_int<512> v358 = v344[((v354 + (v347 * 2)) + (v352 * 2))][((v355 + (v353 * 8)) + (v350 * 16))][((v357 + (v356 * 4)) + (v351 * 4))];	// L716
                        bool v359 = v357 < 2;	// L717
                        if (v359) {	// L718
                          v346.write(v358); //v346                          v346 = v358;	// L719
                        } else {
                          v345.write(v358); //v345                          v345 = v358;	// L721
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load0_top(
  ap_int<512> v360[2][32][8],
  hls::stream< ap_int<512> > &v361 /* v361[1] */,
  hls::stream< ap_int<512> > &v362 /* v362[1] */
){
  #pragma HLS inline OFF
  load0<0>(v360, v361, v362);	// L737
}

template<int NC>
void load0_1(
  hls::stream< ap_int<128> > &v363 /* v363[1] */,
  hls::stream< ap_int<512> > &v364 /* v364[1] */
){
  #pragma HLS inline OFF
  for (int v365 = 0; v365 < 1; v365++) {	// L741
    for (int v366 = 0; v366 < 1; v366++) {	// L742
      for (int v367 = 0; v367 < 1; v367++) {	// L743
        for (int v368 = 0; v368 < 2; v368++) {	// L744
          for (int v369 = 0; v369 < 2; v369++) {	// L745
            for (int v370 = 0; v370 < 1; v370++) {	// L746
              for (int v371 = 0; v371 < 2; v371++) {	// L747
                for (int v372 = 0; v372 < 2; v372++) {	// L748
                  for (int v373 = 0; v373 < 8; v373++) {	// L749
                    for (int v374 = 0; v374 < 1; v374++) {	// L750
                      for (int v375 = 0; v375 < 2; v375++) {	// L751
                      #pragma HLS pipeline II=4
                        ap_int<512> v376 = v364.read(); //v364                        v376 = v364;	// L752
                        for (int v377 = 0; v377 < 4; v377++) {	// L753
                        #pragma HLS pipeline II=1
                          int v378 = ((v377 * 128) + 127);	// L754
                          int v379 = (v377 * 128);	// L755
                          ap_int<128> v380 = v376(v378, v379);	// L756
                          v363.write(v380); //v363                          v363 = v380;	// L757
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load0_1_top(
  hls::stream< ap_int<128> > &v381 /* v381[1] */,
  hls::stream< ap_int<512> > &v382 /* v382[1] */,
  hls::stream< ap_int<128> > &v383 /* v383[1] */,
  hls::stream< ap_int<512> > &v384 /* v384[1] */
){
  #pragma HLS inline OFF
  load0_1<0>(v381, v382);	// L773
  load0_1<1>(v383, v384);	// L774
}

template<int NC>
void load1(
  ap_int<512> v385[32][4],
  hls::stream< ap_int<512> > &v386 /* v386[1] */,
  hls::stream< ap_int<512> > &v387 /* v387[1] */
){
  #pragma HLS inline OFF
  for (int v388 = 0; v388 < 1; v388++) {	// L779
    for (int v389 = 0; v389 < 1; v389++) {	// L780
      for (int v390 = 0; v390 < 1; v390++) {	// L781
        for (int v391 = 0; v391 < 2; v391++) {	// L782
          for (int v392 = 0; v392 < 2; v392++) {	// L783
            for (int v393 = 0; v393 < 2; v393++) {	// L784
              for (int v394 = 0; v394 < 8; v394++) {	// L785
                for (int v395 = 0; v395 < 2; v395++) {	// L786
                  for (int v396 = 0; v396 < 2; v396++) {	// L787
                  #pragma HLS pipeline II=1
                    ap_int<512> v397 = v385[((v394 + (v393 * 8)) + (v391 * 16))][((v396 + (v395 * 2)) + (v389 * 4))];	// L788
                    bool v398 = v396 < 1;	// L789
                    if (v398) {	// L790
                      v387.write(v397); //v387                      v387 = v397;	// L791
                    } else {
                      v386.write(v397); //v386                      v386 = v397;	// L793
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load1_top(
  ap_int<512> v399[32][4],
  hls::stream< ap_int<512> > &v400 /* v400[1] */,
  hls::stream< ap_int<512> > &v401 /* v401[1] */
){
  #pragma HLS inline OFF
  load1<0>(v399, v400, v401);	// L807
}

template<int NC>
void load1_1(
  hls::stream< ap_int<128> > &v402 /* v402[1] */,
  hls::stream< ap_int<512> > &v403 /* v403[1] */
){
  #pragma HLS inline OFF
  for (int v404 = 0; v404 < 1; v404++) {	// L811
    for (int v405 = 0; v405 < 1; v405++) {	// L812
      for (int v406 = 0; v406 < 1; v406++) {	// L813
        for (int v407 = 0; v407 < 2; v407++) {	// L814
          for (int v408 = 0; v408 < 2; v408++) {	// L815
            for (int v409 = 0; v409 < 2; v409++) {	// L816
              for (int v410 = 0; v410 < 8; v410++) {	// L817
                for (int v411 = 0; v411 < 2; v411++) {	// L818
                  for (int v412 = 0; v412 < 1; v412++) {	// L819
                  #pragma HLS pipeline II=4
                    ap_int<512> v413 = v403.read(); //v403                    v413 = v403;	// L820
                    for (int v414 = 0; v414 < 4; v414++) {	// L821
                    #pragma HLS pipeline II=1
                      int v415 = ((v414 * 128) + 127);	// L822
                      int v416 = (v414 * 128);	// L823
                      ap_int<128> v417 = v413(v415, v416);	// L824
                      v402.write(v417); //v402                      v402 = v417;	// L825
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load1_1_top(
  hls::stream< ap_int<128> > &v418 /* v418[1] */,
  hls::stream< ap_int<512> > &v419 /* v419[1] */,
  hls::stream< ap_int<128> > &v420 /* v420[1] */,
  hls::stream< ap_int<512> > &v421 /* v421[1] */
){
  #pragma HLS inline OFF
  load1_1<0>(v418, v419);	// L839
  load1_1<1>(v420, v421);	// L840
}

void ttmc_pl(
  ap_int<512> v422[2][32][8],
  ap_int<512> v423[32][4],
  ap_int<512> v424[128][4],
  ap_int<512> v425[2][64][4],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v426 /* v426[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v427 /* v427[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v428 /* v428[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v429 /* v429[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v430 /* v430[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v431 /* v431[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v432 /* v432[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v433 /* v433[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v434 /* v434[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v435 /* v435[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v436 /* v436[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v437 /* v437[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v438 /* v438[1] */;	// L844
  hls::stream< ap_int<128> > v439 /* v439[1] */;	// L845
  hls::stream< ap_int<128> > v440 /* v440[1] */;	// L846
  hls::stream< ap_int<128> > v441 /* v441[1] */;	// L847
  hls::stream< ap_int<128> > v442 /* v442[1] */;	// L848
  hls::stream< ap_int<128> > v443 /* v443[1] */;	// L849
  hls::stream< ap_int<128> > v444 /* v444[1] */;	// L850
  hls::stream< ap_int<128> > v445 /* v445[1] */;	// L851
  hls::stream< ap_int<128> > v446 /* v446[1] */;	// L852
  hls::stream< ap_int<128> > v447 /* v447[1] */;	// L853
  hls::stream< ap_int<128> > v448 /* v448[1] */;	// L854
  hls::stream< ap_int<128> > v449 /* v449[1] */;	// L855
  hls::stream< ap_int<512> > v450 /* v450[1] */;	// L856
  #pragma HLS stream variable=v450 depth=1
  hls::stream< ap_int<512> > v451 /* v451[1] */;	// L857
  #pragma HLS stream variable=v451 depth=1
  hls::stream< ap_int<512> > v452 /* v452[1] */;	// L858
  #pragma HLS stream variable=v452 depth=1
  hls::stream< ap_int<512> > v453 /* v453[1] */;	// L859
  #pragma HLS stream variable=v453 depth=1
  hls::stream< ap_int<512> > v454 /* v454[1] */;	// L860
  #pragma HLS stream variable=v454 depth=1
  hls::stream< ap_int<512> > v455 /* v455[1] */;	// L861
  #pragma HLS stream variable=v455 depth=1
  hls::stream< ap_int<512> > v456 /* v456[1] */;	// L862
  #pragma HLS stream variable=v456 depth=1
  hls::stream< ap_int<512> > v457 /* v457[1] */;	// L863
  #pragma HLS stream variable=v457 depth=1
  hls::stream< ap_int<512> > v458 /* v458[1] */;	// L864
  #pragma HLS stream variable=v458 depth=2
  hls::stream< ap_int<512> > v459 /* v459[1] */;	// L865
  #pragma HLS stream variable=v459 depth=2
  hls::stream< ap_int<512> > v460 /* v460[1] */;	// L866
  #pragma HLS stream variable=v460 depth=1
  hls::stream< ap_int<512> > v461 /* v461[1] */;	// L867
  #pragma HLS stream variable=v461 depth=1
  send3_top(v434, v446, v437, v449);	// L868
  load2_top(v424, v450, v451, v452, v453);	// L869
  load2_3_top(v447, v453, v445, v452, v444, v451, v443, v450);	// L870
  send5_top(v431, v444, v430, v443, v433, v445, v435, v447);	// L871
  send1_top(v436, v448, v428, v442);	// L872
  receive2_top(v427, v440, v432, v438, v426, v441, v429, v439);	// L873
  store0_0_top(v441, v454, v440, v455, v439, v456, v438, v457);	// L874
  store0_top(v425, v454, v455, v456, v457);	// L875
  load0_top(v422, v458, v459);	// L876
  load0_1_top(v449, v459, v446, v458);	// L877
  load1_top(v423, v460, v461);	// L878
  load1_1_top(v448, v461, v442, v460);	// L879
}

void top(
  ap_int<512> v462[2][32][8],
  ap_int<512> v463[32][4],
  ap_int<512> v464[128][4],
  ap_int<512> v465[2][64][4],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v466 /* v466[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v467 /* v467[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v468 /* v468[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v469 /* v469[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v470 /* v470[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v471 /* v471[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v472 /* v472[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v473 /* v473[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v474 /* v474[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v475 /* v475[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v476 /* v476[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v477 /* v477[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v462
  #pragma HLS interface s_axilite bundle=control port=v462
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v463
  #pragma HLS interface s_axilite bundle=control port=v463
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v464
  #pragma HLS interface s_axilite bundle=control port=v464
  #pragma HLS interface m_axi offset=slave bundle=gmem3 port=v465
  #pragma HLS interface s_axilite bundle=control port=v465
  #pragma HLS interface axis port=v466
  #pragma HLS interface axis port=v467
  #pragma HLS interface axis port=v468
  #pragma HLS interface axis port=v469
  #pragma HLS interface axis port=v470
  #pragma HLS interface axis port=v471
  #pragma HLS interface axis port=v472
  #pragma HLS interface axis port=v473
  #pragma HLS interface axis port=v474
  #pragma HLS interface axis port=v475
  #pragma HLS interface axis port=v476
  #pragma HLS interface axis port=v477

  ttmc_pl(v462, v463, v464, v465, v466, v467, v468, v469, v470, v471, v472, v473, v474, v475, v476, v477);	// L918
}


