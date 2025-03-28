
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
  ap_int<128> v49[4][8][8],
  bool v50
){
  #pragma HLS inline OFF
  if (v50) {	// L192
    for (int v51 = 0; v51 < 2; v51++) {	// L193
      for (int v52 = 0; v52 < 2; v52++) {	// L194
        for (int v53 = 0; v53 < 2; v53++) {	// L195
          for (int v54 = 0; v54 < 4; v54++) {	// L196
            for (int v55 = 0; v55 < 1; v55++) {	// L197
              for (int v56 = 0; v56 < 8; v56++) {	// L198
              #pragma HLS pipeline II=1
                ap_int<128> v57 = v48.read(); //v48                v57 = v48;	// L199
                v49[(v53 + (v51 * 2))][(v54 + (v52 * 4))][(v56 + (v55 * 8))] = v57;	// L200
              }
            }
          }
        }
      }
    }
  }
}

void send3_1(
  ap_int<128> v58[4][8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v59 /* v59[1] */,
  bool v60
){
  #pragma HLS inline OFF
  if (v60) {	// L211
    for (int v61 = 0; v61 < 2; v61++) {	// L212
      for (int v62 = 0; v62 < 2; v62++) {	// L213
        for (int v63 = 0; v63 < 2; v63++) {	// L214
          for (int v64 = 0; v64 < 2; v64++) {	// L215
            for (int v65 = 0; v65 < 1; v65++) {	// L216
              for (int v66 = 0; v66 < 2; v66++) {	// L217
                for (int v67 = 0; v67 < 4; v67++) {	// L218
                  for (int v68 = 0; v68 < 8; v68++) {	// L219
                  #pragma HLS pipeline II=1
                    ap_int<128> v69 = v58[(v66 + (v61 * 2))][(v67 + (v64 * 4))][(v68 + (v65 * 8))];	// L220
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
  ap_int<128> v72[4][8][8];	// L238
  #pragma HLS bind_storage variable=v72 type=ram_t2p impl=uram
  ap_int<128> v73[4][8][8];	// L239
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
                      v95.write(v114); //v95                      v95 = v114;	// L305
                    } else {
                      v97.write(v114); //v97                      v97 = v114;	// L307
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
  hls::stream< ap_int<512> > &v121 /* v121[1] */,
  hls::stream< ap_int<128> > &v122 /* v122[1] */
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
                    ap_int<512> v132 = v121.read(); //v121                    v132 = v121;	// L334
                    for (int v133 = 0; v133 < 4; v133++) {	// L335
                    #pragma HLS pipeline II=1
                      int v134 = ((v133 * 128) + 127);	// L336
                      int v135 = (v133 * 128);	// L337
                      ap_int<128> v136 = v132(v134, v135);	// L338
                      v122.write(v136); //v122                      v122 = v136;	// L339
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
  hls::stream< ap_int<512> > &v137 /* v137[1] */,
  hls::stream< ap_int<128> > &v138 /* v138[1] */,
  hls::stream< ap_int<512> > &v139 /* v139[1] */,
  hls::stream< ap_int<128> > &v140 /* v140[1] */,
  hls::stream< ap_int<512> > &v141 /* v141[1] */,
  hls::stream< ap_int<128> > &v142 /* v142[1] */,
  hls::stream< ap_int<512> > &v143 /* v143[1] */,
  hls::stream< ap_int<128> > &v144 /* v144[1] */
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
    for (int v156 = 0; v156 < 2; v156++) {	// L376
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
  ap_int<128> v193[8][8],
  bool v194
){
  #pragma HLS inline OFF
  if (v194) {	// L441
    for (int v195 = 0; v195 < 2; v195++) {	// L442
      for (int v196 = 0; v196 < 4; v196++) {	// L443
        for (int v197 = 0; v197 < 2; v197++) {	// L444
          for (int v198 = 0; v198 < 4; v198++) {	// L445
          #pragma HLS pipeline II=1
            ap_int<128> v199 = v192.read(); //v192            v199 = v192;	// L446
            v193[(v196 + (v195 * 4))][(v198 + (v197 * 4))] = v199;	// L447
          }
        }
      }
    }
  }
}

void send1_1(
  ap_int<128> v200[8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v201 /* v201[1] */,
  bool v202
){
  #pragma HLS inline OFF
  if (v202) {	// L456
    for (int v203 = 0; v203 < 2; v203++) {	// L457
      for (int v204 = 0; v204 < 2; v204++) {	// L458
        for (int v205 = 0; v205 < 2; v205++) {	// L459
          for (int v206 = 0; v206 < 2; v206++) {	// L460
            for (int v207 = 0; v207 < 1; v207++) {	// L461
              for (int v208 = 0; v208 < 4; v208++) {	// L462
                for (int v209 = 0; v209 < 4; v209++) {	// L463
                #pragma HLS pipeline II=1
                  ap_int<128> v210 = v200[(v208 + (v206 * 4))][(v209 + (v204 * 4))];	// L464
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
  ap_int<128> v213[8][8];	// L481
  #pragma HLS bind_storage variable=v213 type=ram_s2p impl=bram
  ap_int<128> v214[8][8];	// L482
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
  ap_int<128> v237[4][32][8];	// L529
  #pragma HLS bind_storage variable=v237 type=ram_s2p impl=bram
  for (int v238 = 0; v238 < 4; v238++) {	// L530
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
            for (int v246 = 0; v246 < 2; v246++) {	// L542
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
                            float v261;
                            union { int32_t from; float to;} _converter_v259_to_v261;
                            _converter_v259_to_v261.from = v259;
                            v261 = _converter_v259_to_v261.to;	// L557
                            float v262;
                            union { int32_t from; float to;} _converter_v260_to_v262;
                            _converter_v260_to_v262.from = v260;
                            v262 = _converter_v260_to_v262.to;	// L558
                            float v263 = v261 + v262;	// L559
                            int32_t v264;
                            union { float from; int32_t to;} _converter_v263_to_v264;
                            _converter_v263_to_v264.from = v263;
                            v264 = _converter_v263_to_v264.to;	// L560
                            v258(31, 0) = v264;	// L561
                            int32_t v265 = v256(63, 32);	// L562
                            int32_t v266 = v257(63, 32);	// L563
                            float v267;
                            union { int32_t from; float to;} _converter_v265_to_v267;
                            _converter_v265_to_v267.from = v265;
                            v267 = _converter_v265_to_v267.to;	// L564
                            float v268;
                            union { int32_t from; float to;} _converter_v266_to_v268;
                            _converter_v266_to_v268.from = v266;
                            v268 = _converter_v266_to_v268.to;	// L565
                            float v269 = v267 + v268;	// L566
                            int32_t v270;
                            union { float from; int32_t to;} _converter_v269_to_v270;
                            _converter_v269_to_v270.from = v269;
                            v270 = _converter_v269_to_v270.to;	// L567
                            v258(63, 32) = v270;	// L568
                            int32_t v271 = v256(95, 64);	// L569
                            int32_t v272 = v257(95, 64);	// L570
                            float v273;
                            union { int32_t from; float to;} _converter_v271_to_v273;
                            _converter_v271_to_v273.from = v271;
                            v273 = _converter_v271_to_v273.to;	// L571
                            float v274;
                            union { int32_t from; float to;} _converter_v272_to_v274;
                            _converter_v272_to_v274.from = v272;
                            v274 = _converter_v272_to_v274.to;	// L572
                            float v275 = v273 + v274;	// L573
                            int32_t v276;
                            union { float from; int32_t to;} _converter_v275_to_v276;
                            _converter_v275_to_v276.from = v275;
                            v276 = _converter_v275_to_v276.to;	// L574
                            v258(95, 64) = v276;	// L575
                            int32_t v277 = v256(127, 96);	// L576
                            int32_t v278 = v257(127, 96);	// L577
                            float v279;
                            union { int32_t from; float to;} _converter_v277_to_v279;
                            _converter_v277_to_v279.from = v277;
                            v279 = _converter_v277_to_v279.to;	// L578
                            float v280;
                            union { int32_t from; float to;} _converter_v278_to_v280;
                            _converter_v278_to_v280.from = v278;
                            v280 = _converter_v278_to_v280.to;	// L579
                            float v281 = v279 + v280;	// L580
                            int32_t v282;
                            union { float from; int32_t to;} _converter_v281_to_v282;
                            _converter_v281_to_v282.from = v281;
                            v282 = _converter_v281_to_v282.to;	// L581
                            v258(127, 96) = v282;	// L582
                            ap_int<128> v283 = v258;
                            v237[(v251 + (v246 * 2))][(v252 + (v247 * 16))][(v253 + (v248 * 4))] = v283;	// L584
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
        for (int v284 = 0; v284 < 2; v284++) {	// L595
          for (int v285 = 0; v285 < 2; v285++) {	// L596
            for (int v286 = 0; v286 < 2; v286++) {	// L597
              for (int v287 = 0; v287 < 16; v287++) {	// L598
                for (int v288 = 0; v288 < 2; v288++) {	// L599
                  for (int v289 = 0; v289 < 4; v289++) {	// L600
                  #pragma HLS pipeline II=1
                    ap_int<128> v290 = v237[(v286 + (v284 * 2))][(v287 + (v285 * 16))][(v289 + (v288 * 4))];	// L601
                    v236.write(v290); //v236                    v236 = v290;	// L602
                    v237[(v286 + (v284 * 2))][(v287 + (v285 * 16))][(v289 + (v288 * 4))] = 0;	// L603
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
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v291 /* v291[1] */,
  hls::stream< ap_int<128> > &v292 /* v292[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v293 /* v293[1] */,
  hls::stream< ap_int<128> > &v294 /* v294[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v295 /* v295[1] */,
  hls::stream< ap_int<128> > &v296 /* v296[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v297 /* v297[1] */,
  hls::stream< ap_int<128> > &v298 /* v298[1] */
){
  #pragma HLS inline OFF
  receive2<0>(v291, v292);	// L616
  receive2<1>(v293, v294);	// L617
  receive2<2>(v295, v296);	// L618
  receive2<3>(v297, v298);	// L619
}

template<int NC>
void store0_0(
  hls::stream< ap_int<128> > &v299 /* v299[1] */,
  hls::stream< ap_int<512> > &v300 /* v300[1] */
){
  #pragma HLS inline OFF
  for (int v301 = 0; v301 < 1; v301++) {	// L624
    for (int v302 = 0; v302 < 1; v302++) {	// L625
      for (int v303 = 0; v303 < 1; v303++) {	// L626
        for (int v304 = 0; v304 < 2; v304++) {	// L627
          for (int v305 = 0; v305 < 2; v305++) {	// L628
            for (int v306 = 0; v306 < 2; v306++) {	// L629
              for (int v307 = 0; v307 < 16; v307++) {	// L630
                for (int v308 = 0; v308 < 2; v308++) {	// L631
                  for (int v309 = 0; v309 < 1; v309++) {	// L632
                  #pragma HLS pipeline II=4
                    ap_int<512> v310 = 0;
                    for (int v311 = 0; v311 < 4; v311++) {	// L634
                    #pragma HLS pipeline II=1
                      ap_int<128> v312 = v299.read(); //v299                      v312 = v299;	// L635
                      int v313 = ((v311 * 128) + 127);	// L636
                      int v314 = (v311 * 128);	// L637
                      v310(v313, v314) = v312;	// L638
                    }
                    v300.write(v310); //v300                    v300 = v310;	// L640
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
  hls::stream< ap_int<128> > &v315 /* v315[1] */,
  hls::stream< ap_int<512> > &v316 /* v316[1] */,
  hls::stream< ap_int<128> > &v317 /* v317[1] */,
  hls::stream< ap_int<512> > &v318 /* v318[1] */,
  hls::stream< ap_int<128> > &v319 /* v319[1] */,
  hls::stream< ap_int<512> > &v320 /* v320[1] */,
  hls::stream< ap_int<128> > &v321 /* v321[1] */,
  hls::stream< ap_int<512> > &v322 /* v322[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v315, v316);	// L653
  store0_0<1>(v317, v318);	// L654
  store0_0<2>(v319, v320);	// L655
  store0_0<3>(v321, v322);	// L656
}

template<int NC>
void store0(
  ap_int<512> v323[4][64][4],
  hls::stream< ap_int<512> > &v324 /* v324[1] */,
  hls::stream< ap_int<512> > &v325 /* v325[1] */,
  hls::stream< ap_int<512> > &v326 /* v326[1] */,
  hls::stream< ap_int<512> > &v327 /* v327[1] */
){
  #pragma HLS inline OFF
  for (int v328 = 0; v328 < 1; v328++) {	// L661
    for (int v329 = 0; v329 < 1; v329++) {	// L662
      for (int v330 = 0; v330 < 1; v330++) {	// L663
        for (int v331 = 0; v331 < 2; v331++) {	// L664
          for (int v332 = 0; v332 < 2; v332++) {	// L665
            for (int v333 = 0; v333 < 2; v333++) {	// L666
              for (int v334 = 0; v334 < 16; v334++) {	// L667
                for (int v335 = 0; v335 < 2; v335++) {	// L668
                  for (int v336 = 0; v336 < 2; v336++) {	// L669
                  #pragma HLS pipeline II=1
                    bool v337 = v336 < 1;	// L670
                    ap_int<512> v338;
                    if (v337) {	// L671
                      ap_int<512> v339 = v325.read(); //v325                      v339 = v325;	// L672
                      v338 = v339;	// L673
                    } else {
                      ap_int<512> v340 = v324.read(); //v324                      v340 = v324;	// L675
                      v338 = v340;	// L676
                    }
                    v323[((v333 + (v331 * 2)) + (v328 * 4))][((v334 + (v332 * 32)) + (v329 * 64))][((v336 + (v335 * 2)) + (v330 * 4))] = v338;	// L678
                  }
                }
              }
            }
          }
        }
        for (int v341 = 0; v341 < 2; v341++) {	// L685
          for (int v342 = 0; v342 < 2; v342++) {	// L686
            for (int v343 = 0; v343 < 2; v343++) {	// L687
              for (int v344 = 0; v344 < 16; v344++) {	// L688
                for (int v345 = 0; v345 < 2; v345++) {	// L689
                  for (int v346 = 0; v346 < 2; v346++) {	// L690
                  #pragma HLS pipeline II=1
                    bool v347 = v346 < 1;	// L691
                    ap_int<512> v348;
                    if (v347) {	// L692
                      ap_int<512> v349 = v326.read(); //v326                      v349 = v326;	// L693
                      v348 = v349;	// L694
                    } else {
                      ap_int<512> v350 = v327.read(); //v327                      v350 = v327;	// L696
                      v348 = v350;	// L697
                    }
                    v323[((v343 + (v341 * 2)) + (v328 * 4))][(((v344 + (v342 * 32)) + (v329 * 64)) + 16)][((v346 + (v345 * 2)) + (v330 * 4))] = v348;	// L699
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
  ap_int<512> v351[4][64][4],
  hls::stream< ap_int<512> > &v352 /* v352[1] */,
  hls::stream< ap_int<512> > &v353 /* v353[1] */,
  hls::stream< ap_int<512> > &v354 /* v354[1] */,
  hls::stream< ap_int<512> > &v355 /* v355[1] */
){
  #pragma HLS inline OFF
  store0<0>(v351, v352, v353, v354, v355);	// L712
}

template<int NC>
void load0(
  ap_int<512> v356[4][16][8],
  hls::stream< ap_int<512> > &v357 /* v357[1] */,
  hls::stream< ap_int<512> > &v358 /* v358[1] */
){
  #pragma HLS inline OFF
  for (int v359 = 0; v359 < 1; v359++) {	// L717
    for (int v360 = 0; v360 < 1; v360++) {	// L718
      for (int v361 = 0; v361 < 1; v361++) {	// L719
        for (int v362 = 0; v362 < 2; v362++) {	// L720
          for (int v363 = 0; v363 < 2; v363++) {	// L721
            for (int v364 = 0; v364 < 2; v364++) {	// L722
              for (int v365 = 0; v365 < 2; v365++) {	// L723
                for (int v366 = 0; v366 < 2; v366++) {	// L724
                  for (int v367 = 0; v367 < 4; v367++) {	// L725
                    for (int v368 = 0; v368 < 1; v368++) {	// L726
                      for (int v369 = 0; v369 < 4; v369++) {	// L727
                      #pragma HLS pipeline II=1
                        ap_int<512> v370 = v356[((v366 + (v364 * 2)) + (v359 * 4))][((v367 + (v365 * 4)) + (v362 * 8))][((v369 + (v368 * 4)) + (v363 * 4))];	// L728
                        bool v371 = v369 < 2;	// L729
                        if (v371) {	// L730
                          v357.write(v370); //v357                          v357 = v370;	// L731
                        } else {
                          v358.write(v370); //v358                          v358 = v370;	// L733
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
  ap_int<512> v372[4][16][8],
  hls::stream< ap_int<512> > &v373 /* v373[1] */,
  hls::stream< ap_int<512> > &v374 /* v374[1] */
){
  #pragma HLS inline OFF
  load0<0>(v372, v373, v374);	// L749
}

template<int NC>
void load0_1(
  hls::stream< ap_int<512> > &v375 /* v375[1] */,
  hls::stream< ap_int<128> > &v376 /* v376[1] */
){
  #pragma HLS inline OFF
  for (int v377 = 0; v377 < 1; v377++) {	// L753
    for (int v378 = 0; v378 < 1; v378++) {	// L754
      for (int v379 = 0; v379 < 1; v379++) {	// L755
        for (int v380 = 0; v380 < 2; v380++) {	// L756
          for (int v381 = 0; v381 < 2; v381++) {	// L757
            for (int v382 = 0; v382 < 2; v382++) {	// L758
              for (int v383 = 0; v383 < 2; v383++) {	// L759
                for (int v384 = 0; v384 < 2; v384++) {	// L760
                  for (int v385 = 0; v385 < 4; v385++) {	// L761
                    for (int v386 = 0; v386 < 1; v386++) {	// L762
                      for (int v387 = 0; v387 < 2; v387++) {	// L763
                      #pragma HLS pipeline II=4
                        ap_int<512> v388 = v375.read(); //v375                        v388 = v375;	// L764
                        for (int v389 = 0; v389 < 4; v389++) {	// L765
                        #pragma HLS pipeline II=1
                          int v390 = ((v389 * 128) + 127);	// L766
                          int v391 = (v389 * 128);	// L767
                          ap_int<128> v392 = v388(v390, v391);	// L768
                          v376.write(v392); //v376                          v376 = v392;	// L769
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
  hls::stream< ap_int<512> > &v393 /* v393[1] */,
  hls::stream< ap_int<128> > &v394 /* v394[1] */,
  hls::stream< ap_int<512> > &v395 /* v395[1] */,
  hls::stream< ap_int<128> > &v396 /* v396[1] */
){
  #pragma HLS inline OFF
  load0_1<0>(v393, v394);	// L785
  load0_1<1>(v395, v396);	// L786
}

template<int NC>
void load1(
  ap_int<512> v397[16][4],
  hls::stream< ap_int<512> > &v398 /* v398[1] */,
  hls::stream< ap_int<512> > &v399 /* v399[1] */
){
  #pragma HLS inline OFF
  for (int v400 = 0; v400 < 1; v400++) {	// L791
    for (int v401 = 0; v401 < 1; v401++) {	// L792
      for (int v402 = 0; v402 < 1; v402++) {	// L793
        for (int v403 = 0; v403 < 2; v403++) {	// L794
          for (int v404 = 0; v404 < 2; v404++) {	// L795
            for (int v405 = 0; v405 < 2; v405++) {	// L796
              for (int v406 = 0; v406 < 4; v406++) {	// L797
                for (int v407 = 0; v407 < 2; v407++) {	// L798
                  for (int v408 = 0; v408 < 2; v408++) {	// L799
                  #pragma HLS pipeline II=1
                    ap_int<512> v409 = v397[((v406 + (v405 * 4)) + (v403 * 8))][((v408 + (v407 * 2)) + (v401 * 4))];	// L800
                    bool v410 = v408 < 1;	// L801
                    if (v410) {	// L802
                      v399.write(v409); //v399                      v399 = v409;	// L803
                    } else {
                      v398.write(v409); //v398                      v398 = v409;	// L805
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
  ap_int<512> v411[16][4],
  hls::stream< ap_int<512> > &v412 /* v412[1] */,
  hls::stream< ap_int<512> > &v413 /* v413[1] */
){
  #pragma HLS inline OFF
  load1<0>(v411, v412, v413);	// L819
}

template<int NC>
void load1_1(
  hls::stream< ap_int<512> > &v414 /* v414[1] */,
  hls::stream< ap_int<128> > &v415 /* v415[1] */
){
  #pragma HLS inline OFF
  for (int v416 = 0; v416 < 1; v416++) {	// L823
    for (int v417 = 0; v417 < 1; v417++) {	// L824
      for (int v418 = 0; v418 < 1; v418++) {	// L825
        for (int v419 = 0; v419 < 2; v419++) {	// L826
          for (int v420 = 0; v420 < 2; v420++) {	// L827
            for (int v421 = 0; v421 < 2; v421++) {	// L828
              for (int v422 = 0; v422 < 4; v422++) {	// L829
                for (int v423 = 0; v423 < 2; v423++) {	// L830
                  for (int v424 = 0; v424 < 1; v424++) {	// L831
                  #pragma HLS pipeline II=4
                    ap_int<512> v425 = v414.read(); //v414                    v425 = v414;	// L832
                    for (int v426 = 0; v426 < 4; v426++) {	// L833
                    #pragma HLS pipeline II=1
                      int v427 = ((v426 * 128) + 127);	// L834
                      int v428 = (v426 * 128);	// L835
                      ap_int<128> v429 = v425(v427, v428);	// L836
                      v415.write(v429); //v415                      v415 = v429;	// L837
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
  hls::stream< ap_int<512> > &v430 /* v430[1] */,
  hls::stream< ap_int<128> > &v431 /* v431[1] */,
  hls::stream< ap_int<512> > &v432 /* v432[1] */,
  hls::stream< ap_int<128> > &v433 /* v433[1] */
){
  #pragma HLS inline OFF
  load1_1<0>(v430, v431);	// L851
  load1_1<1>(v432, v433);	// L852
}

void ttmc_pl(
  ap_int<512> v434[4][16][8],
  ap_int<512> v435[16][4],
  ap_int<512> v436[128][4],
  ap_int<512> v437[4][64][4],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v438 /* v438[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v439 /* v439[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v440 /* v440[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v441 /* v441[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v442 /* v442[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v443 /* v443[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v444 /* v444[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v445 /* v445[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v446 /* v446[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v447 /* v447[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v448 /* v448[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v449 /* v449[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v450 /* v450[1] */;	// L857
  hls::stream< ap_int<128> > v451 /* v451[1] */;	// L858
  hls::stream< ap_int<128> > v452 /* v452[1] */;	// L859
  hls::stream< ap_int<128> > v453 /* v453[1] */;	// L860
  hls::stream< ap_int<128> > v454 /* v454[1] */;	// L861
  hls::stream< ap_int<128> > v455 /* v455[1] */;	// L862
  hls::stream< ap_int<128> > v456 /* v456[1] */;	// L863
  hls::stream< ap_int<128> > v457 /* v457[1] */;	// L864
  hls::stream< ap_int<128> > v458 /* v458[1] */;	// L865
  hls::stream< ap_int<128> > v459 /* v459[1] */;	// L866
  hls::stream< ap_int<128> > v460 /* v460[1] */;	// L867
  hls::stream< ap_int<128> > v461 /* v461[1] */;	// L868
  ap_int<128> v462[4][32][8];	// L869
  #pragma HLS bind_storage variable=v462 type=ram_s2p impl=bram
  for (int v463 = 0; v463 < 4; v463++) {	// L870
    for (int v464 = 0; v464 < 32; v464++) {	// L871
      for (int v465 = 0; v465 < 8; v465++) {	// L872
      #pragma HLS pipeline II=1
        v462[v463][v464][v465] = 0;	// L873
      }
    }
  }
  ap_int<128> v466[4][32][8];	// L877
  #pragma HLS bind_storage variable=v466 type=ram_s2p impl=bram
  for (int v467 = 0; v467 < 4; v467++) {	// L878
    for (int v468 = 0; v468 < 32; v468++) {	// L879
      for (int v469 = 0; v469 < 8; v469++) {	// L880
      #pragma HLS pipeline II=1
        v466[v467][v468][v469] = 0;	// L881
      }
    }
  }
  ap_int<128> v470[4][32][8];	// L885
  #pragma HLS bind_storage variable=v470 type=ram_s2p impl=bram
  for (int v471 = 0; v471 < 4; v471++) {	// L886
    for (int v472 = 0; v472 < 32; v472++) {	// L887
      for (int v473 = 0; v473 < 8; v473++) {	// L888
      #pragma HLS pipeline II=1
        v470[v471][v472][v473] = 0;	// L889
      }
    }
  }
  ap_int<128> v474[4][32][8];	// L893
  #pragma HLS bind_storage variable=v474 type=ram_s2p impl=bram
  for (int v475 = 0; v475 < 4; v475++) {	// L894
    for (int v476 = 0; v476 < 32; v476++) {	// L895
      for (int v477 = 0; v477 < 8; v477++) {	// L896
      #pragma HLS pipeline II=1
        v474[v475][v476][v477] = 0;	// L897
      }
    }
  }
  hls::stream< ap_int<512> > v478 /* v478[1] */;	// L901
  #pragma HLS stream variable=v478 depth=1
  hls::stream< ap_int<512> > v479 /* v479[1] */;	// L902
  #pragma HLS stream variable=v479 depth=1
  hls::stream< ap_int<512> > v480 /* v480[1] */;	// L903
  #pragma HLS stream variable=v480 depth=1
  hls::stream< ap_int<512> > v481 /* v481[1] */;	// L904
  #pragma HLS stream variable=v481 depth=1
  hls::stream< ap_int<512> > v482 /* v482[1] */;	// L905
  #pragma HLS stream variable=v482 depth=1
  hls::stream< ap_int<512> > v483 /* v483[1] */;	// L906
  #pragma HLS stream variable=v483 depth=1
  hls::stream< ap_int<512> > v484 /* v484[1] */;	// L907
  #pragma HLS stream variable=v484 depth=1
  hls::stream< ap_int<512> > v485 /* v485[1] */;	// L908
  #pragma HLS stream variable=v485 depth=1
  hls::stream< ap_int<512> > v486 /* v486[1] */;	// L909
  #pragma HLS stream variable=v486 depth=2
  hls::stream< ap_int<512> > v487 /* v487[1] */;	// L910
  #pragma HLS stream variable=v487 depth=2
  hls::stream< ap_int<512> > v488 /* v488[1] */;	// L911
  #pragma HLS stream variable=v488 depth=1
  hls::stream< ap_int<512> > v489 /* v489[1] */;	// L912
  #pragma HLS stream variable=v489 depth=1
  send3_top(v443, v458, v447, v461);	// L913
  load2_top(v436, v480, v479, v478, v481);	// L914
  load2_3_top(v481, v459, v480, v457, v479, v456, v478, v455);	// L915
  send5_top(v446, v456, v448, v455, v449, v457, v439, v459);	// L916
  send1_top(v445, v460, v438, v454);	// L917
  receive2_top(v442, v452, v440, v450, v444, v453, v441, v451);	// L918
  store0_0_top(v453, v482, v452, v483, v451, v484, v450, v485);	// L919
  store0_top(v437, v484, v485, v483, v482);	// L920
  load0_top(v434, v487, v486);	// L921
  load0_1_top(v487, v461, v486, v458);	// L922
  load1_top(v435, v488, v489);	// L923
  load1_1_top(v489, v460, v488, v454);	// L924
}

void top(
  ap_int<512> v490[4][16][8],
  ap_int<512> v491[16][4],
  ap_int<512> v492[128][4],
  ap_int<512> v493[4][64][4],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v494 /* v494[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v495 /* v495[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v496 /* v496[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v497 /* v497[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v498 /* v498[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v499 /* v499[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v500 /* v500[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v501 /* v501[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v502 /* v502[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v503 /* v503[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v504 /* v504[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v505 /* v505[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v490
  #pragma HLS interface s_axilite bundle=control port=v490
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v491
  #pragma HLS interface s_axilite bundle=control port=v491
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v492
  #pragma HLS interface s_axilite bundle=control port=v492
  #pragma HLS interface m_axi offset=slave bundle=gmem3 port=v493
  #pragma HLS interface s_axilite bundle=control port=v493
  #pragma HLS interface axis port=v494
  #pragma HLS interface axis port=v495
  #pragma HLS interface axis port=v496
  #pragma HLS interface axis port=v497
  #pragma HLS interface axis port=v498
  #pragma HLS interface axis port=v499
  #pragma HLS interface axis port=v500
  #pragma HLS interface axis port=v501
  #pragma HLS interface axis port=v502
  #pragma HLS interface axis port=v503
  #pragma HLS interface axis port=v504
  #pragma HLS interface axis port=v505

  ttmc_pl(v490, v491, v492, v493, v494, v495, v496, v497, v498, v499, v500, v501, v502, v503, v504, v505);	// L963
}


