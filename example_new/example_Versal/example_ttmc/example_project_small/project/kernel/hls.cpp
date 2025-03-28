
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
  ap_int<128> v49[4][4][8],
  bool v50
){
  #pragma HLS inline OFF
  if (v50) {	// L192
    for (int v51 = 0; v51 < 2; v51++) {	// L193
      for (int v52 = 0; v52 < 2; v52++) {	// L194
        for (int v53 = 0; v53 < 2; v53++) {	// L195
          for (int v54 = 0; v54 < 2; v54++) {	// L196
            for (int v55 = 0; v55 < 2; v55++) {	// L197
              for (int v56 = 0; v56 < 4; v56++) {	// L198
              #pragma HLS pipeline II=1
                ap_int<128> v57 = v48.read(); //v48                v57 = v48;	// L199
                v49[(v53 + (v51 * 2))][(v54 + (v52 * 2))][(v56 + (v55 * 4))] = v57;	// L200
              }
            }
          }
        }
      }
    }
  }
}

void send3_1(
  ap_int<128> v58[4][4][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v59 /* v59[1] */,
  bool v60
){
  #pragma HLS inline OFF
  if (v60) {	// L211
    for (int v61 = 0; v61 < 2; v61++) {	// L212
      for (int v62 = 0; v62 < 2; v62++) {	// L213
        for (int v63 = 0; v63 < 2; v63++) {	// L214
          for (int v64 = 0; v64 < 2; v64++) {	// L215
            for (int v65 = 0; v65 < 2; v65++) {	// L216
              for (int v66 = 0; v66 < 2; v66++) {	// L217
                for (int v67 = 0; v67 < 2; v67++) {	// L218
                  for (int v68 = 0; v68 < 4; v68++) {	// L219
                  #pragma HLS pipeline II=1
                    ap_int<128> v69 = v58[(v66 + (v61 * 2))][(v67 + (v64 * 2))][(v68 + (v65 * 4))];	// L220
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
  ap_int<128> v72[4][4][8];	// L240
  #pragma HLS bind_storage variable=v72 type=ram_t2p impl=uram
  ap_int<128> v73[4][4][8];	// L241
  #pragma HLS bind_storage variable=v73 type=ram_t2p impl=uram
  for (int v74 = 0; v74 < 2; v74++) {	// L242
    for (int v75 = 0; v75 < 2; v75++) {	// L243
      for (int v76 = 0; v76 < 2; v76++) {	// L244
        for (int v77 = 0; v77 < 2; v77++) {	// L245
          for (int v78 = 0; v78 < 2; v78++) {	// L246
            int v79 = v77 * 2;	// L247
            int v80 = v78 + v79;	// L248
            int v81 = v76 * 4;	// L249
            int v82 = v80 + v81;	// L250
            int v83 = v75 * 8;	// L251
            int v84 = v82 + v83;	// L252
            int v85 = v74 * 16;	// L253
            int v86 = v84 + v85;	// L254
            int v87 = v86 % 2;	// L255
            bool v88 = v87 == 0;	// L256
            bool v89 = v86 != 0;	// L257
            if (v88) {	// L258
              send3_0(v71, v72, 1);	// L259
              send3_1(v73, v70, v89);	// L260
            } else {
              send3_0(v71, v73, 1);	// L262
              send3_1(v72, v70, v89);	// L263
            }
          }
        }
      }
    }
  }
  send3_1(v73, v70, 1);	// L270
}

void send3_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v90 /* v90[1] */,
  hls::stream< ap_int<128> > &v91 /* v91[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v92 /* v92[1] */,
  hls::stream< ap_int<128> > &v93 /* v93[1] */
){
  #pragma HLS inline OFF
  send3<0>(v90, v91);	// L274
  send3<1>(v92, v93);	// L275
}

template<int NC>
void load2(
  ap_int<512> v94[128][8],
  hls::stream< ap_int<512> > &v95 /* v95[1] */,
  hls::stream< ap_int<512> > &v96 /* v96[1] */,
  hls::stream< ap_int<512> > &v97 /* v97[1] */,
  hls::stream< ap_int<512> > &v98 /* v98[1] */
){
  #pragma HLS inline OFF
  for (int v99 = 0; v99 < 2; v99++) {	// L280
    for (int v100 = 0; v100 < 2; v100++) {	// L281
      for (int v101 = 0; v101 < 2; v101++) {	// L282
        for (int v102 = 0; v102 < 2; v102++) {	// L283
          for (int v103 = 0; v103 < 2; v103++) {	// L284
            for (int v104 = 0; v104 < 2; v104++) {	// L285
              for (int v105 = 0; v105 < 16; v105++) {	// L286
                for (int v106 = 0; v106 < 2; v106++) {	// L287
                  for (int v107 = 0; v107 < 2; v107++) {	// L288
                  #pragma HLS pipeline II=1
                    ap_int<512> v108 = v94[((v105 + (v104 * 32)) + (v103 * 64))][((v107 + (v106 * 2)) + (v101 * 4))];	// L289
                    bool v109 = v107 < 1;	// L290
                    if (v109) {	// L291
                      v96.write(v108); //v96                      v96 = v108;	// L292
                    } else {
                      v97.write(v108); //v97                      v97 = v108;	// L294
                    }
                  }
                }
              }
            }
            for (int v110 = 0; v110 < 2; v110++) {	// L300
              for (int v111 = 0; v111 < 16; v111++) {	// L301
                for (int v112 = 0; v112 < 2; v112++) {	// L302
                  for (int v113 = 0; v113 < 2; v113++) {	// L303
                  #pragma HLS pipeline II=1
                    ap_int<512> v114 = v94[(((v111 + (v110 * 32)) + (v103 * 64)) + 16)][((v113 + (v112 * 2)) + (v101 * 4))];	// L304
                    bool v115 = v113 < 1;	// L305
                    if (v115) {	// L306
                      v95.write(v114); //v95                      v95 = v114;	// L307
                    } else {
                      v98.write(v114); //v98                      v98 = v114;	// L309
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
  ap_int<512> v116[128][8],
  hls::stream< ap_int<512> > &v117 /* v117[1] */,
  hls::stream< ap_int<512> > &v118 /* v118[1] */,
  hls::stream< ap_int<512> > &v119 /* v119[1] */,
  hls::stream< ap_int<512> > &v120 /* v120[1] */
){
  #pragma HLS inline OFF
  load2<0>(v116, v117, v118, v119, v120);	// L323
}

template<int NC>
void load2_3(
  hls::stream< ap_int<512> > &v121 /* v121[1] */,
  hls::stream< ap_int<128> > &v122 /* v122[1] */
){
  #pragma HLS inline OFF
  for (int v123 = 0; v123 < 2; v123++) {	// L327
    for (int v124 = 0; v124 < 2; v124++) {	// L328
      for (int v125 = 0; v125 < 2; v125++) {	// L329
        for (int v126 = 0; v126 < 2; v126++) {	// L330
          for (int v127 = 0; v127 < 2; v127++) {	// L331
            for (int v128 = 0; v128 < 2; v128++) {	// L332
              for (int v129 = 0; v129 < 16; v129++) {	// L333
                for (int v130 = 0; v130 < 2; v130++) {	// L334
                  for (int v131 = 0; v131 < 1; v131++) {	// L335
                  #pragma HLS pipeline II=4
                    ap_int<512> v132 = v121.read(); //v121                    v132 = v121;	// L336
                    for (int v133 = 0; v133 < 4; v133++) {	// L337
                    #pragma HLS pipeline II=1
                      int v134 = ((v133 * 128) + 127);	// L338
                      int v135 = (v133 * 128);	// L339
                      ap_int<128> v136 = v132(v134, v135);	// L340
                      v122.write(v136); //v122                      v122 = v136;	// L341
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
  load2_3<0>(v137, v138);	// L355
  load2_3<1>(v139, v140);	// L356
  load2_3<2>(v141, v142);	// L357
  load2_3<3>(v143, v144);	// L358
}

void send5_0(
  hls::stream< ap_int<128> > &v145 /* v145[1] */,
  ap_int<128> v146[32][8],
  bool v147
){
  #pragma HLS inline OFF
  if (v147) {	// L362
    for (int v148 = 0; v148 < 2; v148++) {	// L363
      for (int v149 = 0; v149 < 16; v149++) {	// L364
        for (int v150 = 0; v150 < 2; v150++) {	// L365
          for (int v151 = 0; v151 < 4; v151++) {	// L366
          #pragma HLS pipeline II=1
            ap_int<128> v152 = v145.read(); //v145            v152 = v145;	// L367
            v146[(v149 + (v148 * 16))][(v151 + (v150 * 4))] = v152;	// L368
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
  if (v155) {	// L377
    for (int v156 = 0; v156 < 2; v156++) {	// L378
      for (int v157 = 0; v157 < 2; v157++) {	// L379
        for (int v158 = 0; v158 < 2; v158++) {	// L380
          for (int v159 = 0; v159 < 2; v159++) {	// L381
            for (int v160 = 0; v160 < 2; v160++) {	// L382
              for (int v161 = 0; v161 < 16; v161++) {	// L383
                for (int v162 = 0; v162 < 4; v162++) {	// L384
                #pragma HLS pipeline II=1
                  ap_int<128> v163 = v153[(v161 + (v160 * 16))][(v162 + (v158 * 4))];	// L385
                  ap_axiu<128, 0 ,0 ,0> v154_axiu;
                  v154_axiu.data = v163;
                  v154_axiu.keep = -1;
                  v154.write(v154_axiu); //v154                  v154 = v163;	// L386
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
  ap_int<128> v166[32][8];	// L404
  #pragma HLS bind_storage variable=v166 type=ram_t2p impl=uram
  ap_int<128> v167[32][8];	// L405
  #pragma HLS bind_storage variable=v167 type=ram_t2p impl=uram
  for (int v168 = 0; v168 < 2; v168++) {	// L406
    for (int v169 = 0; v169 < 2; v169++) {	// L407
      for (int v170 = 0; v170 < 2; v170++) {	// L408
        for (int v171 = 0; v171 < 2; v171++) {	// L409
          for (int v172 = 0; v172 < 2; v172++) {	// L410
            int v173 = v171 * 2;	// L411
            int v174 = v172 + v173;	// L412
            int v175 = v170 * 4;	// L413
            int v176 = v174 + v175;	// L414
            int v177 = v169 * 8;	// L415
            int v178 = v176 + v177;	// L416
            int v179 = v168 * 16;	// L417
            int v180 = v178 + v179;	// L418
            int v181 = v180 % 2;	// L419
            bool v182 = v181 == 0;	// L420
            bool v183 = v180 != 0;	// L421
            if (v182) {	// L422
              send5_0(v165, v166, 1);	// L423
              send5_1(v167, v164, v183);	// L424
            } else {
              send5_0(v165, v167, 1);	// L426
              send5_1(v166, v164, v183);	// L427
            }
          }
        }
      }
    }
  }
  send5_1(v167, v164, 1);	// L434
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
  send5<0>(v184, v185);	// L438
  send5<1>(v186, v187);	// L439
  send5<2>(v188, v189);	// L440
  send5<3>(v190, v191);	// L441
}

void send1_0(
  hls::stream< ap_int<128> > &v192 /* v192[1] */,
  ap_int<128> v193[4][8],
  bool v194
){
  #pragma HLS inline OFF
  if (v194) {	// L445
    for (int v195 = 0; v195 < 2; v195++) {	// L446
      for (int v196 = 0; v196 < 2; v196++) {	// L447
        for (int v197 = 0; v197 < 2; v197++) {	// L448
          for (int v198 = 0; v198 < 4; v198++) {	// L449
          #pragma HLS pipeline II=1
            ap_int<128> v199 = v192.read(); //v192            v199 = v192;	// L450
            v193[(v196 + (v195 * 2))][(v198 + (v197 * 4))] = v199;	// L451
          }
        }
      }
    }
  }
}

void send1_1(
  ap_int<128> v200[4][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v201 /* v201[1] */,
  bool v202
){
  #pragma HLS inline OFF
  if (v202) {	// L460
    for (int v203 = 0; v203 < 2; v203++) {	// L461
      for (int v204 = 0; v204 < 2; v204++) {	// L462
        for (int v205 = 0; v205 < 2; v205++) {	// L463
          for (int v206 = 0; v206 < 2; v206++) {	// L464
            for (int v207 = 0; v207 < 2; v207++) {	// L465
              for (int v208 = 0; v208 < 2; v208++) {	// L466
                for (int v209 = 0; v209 < 4; v209++) {	// L467
                #pragma HLS pipeline II=1
                  ap_int<128> v210 = v200[(v208 + (v206 * 2))][(v209 + (v204 * 4))];	// L468
                  ap_axiu<128, 0 ,0 ,0> v201_axiu;
                  v201_axiu.data = v210;
                  v201_axiu.keep = -1;
                  v201.write(v201_axiu); //v201                  v201 = v210;	// L469
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
  ap_int<128> v213[4][8];	// L487
  #pragma HLS bind_storage variable=v213 type=ram_s2p impl=bram
  ap_int<128> v214[4][8];	// L488
  #pragma HLS bind_storage variable=v214 type=ram_s2p impl=bram
  for (int v215 = 0; v215 < 2; v215++) {	// L489
    for (int v216 = 0; v216 < 2; v216++) {	// L490
      for (int v217 = 0; v217 < 2; v217++) {	// L491
        for (int v218 = 0; v218 < 2; v218++) {	// L492
          for (int v219 = 0; v219 < 2; v219++) {	// L493
            int v220 = v218 * 2;	// L494
            int v221 = v219 + v220;	// L495
            int v222 = v217 * 4;	// L496
            int v223 = v221 + v222;	// L497
            int v224 = v216 * 8;	// L498
            int v225 = v223 + v224;	// L499
            int v226 = v215 * 16;	// L500
            int v227 = v225 + v226;	// L501
            int v228 = v227 % 2;	// L502
            bool v229 = v228 == 0;	// L503
            bool v230 = v227 != 0;	// L504
            if (v229) {	// L505
              send1_0(v212, v213, 1);	// L506
              send1_1(v214, v211, v230);	// L507
            } else {
              send1_0(v212, v214, 1);	// L509
              send1_1(v213, v211, v230);	// L510
            }
          }
        }
      }
    }
  }
  send1_1(v214, v211, 1);	// L517
}

void send1_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v231 /* v231[1] */,
  hls::stream< ap_int<128> > &v232 /* v232[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v233 /* v233[1] */,
  hls::stream< ap_int<128> > &v234 /* v234[1] */
){
  #pragma HLS inline OFF
  send1<0>(v231, v232);	// L521
  send1<1>(v233, v234);	// L522
}

template<int NC>
void receive2(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v235 /* v235[1] */,
  hls::stream< ap_int<128> > &v236 /* v236[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v237[4][32][8];	// L535
  #pragma HLS bind_storage variable=v237 type=ram_s2p impl=bram
  for (int v238 = 0; v238 < 4; v238++) {	// L536
    for (int v239 = 0; v239 < 32; v239++) {	// L537
      for (int v240 = 0; v240 < 8; v240++) {	// L538
      #pragma HLS pipeline II=1
        v237[v238][v239][v240] = 0;	// L539
      }
    }
  }
  for (int v241 = 0; v241 < 2; v241++) {	// L543
    for (int v242 = 0; v242 < 2; v242++) {	// L544
      for (int v243 = 0; v243 < 2; v243++) {	// L545
        for (int v244 = 0; v244 < 2; v244++) {	// L546
          for (int v245 = 0; v245 < 2; v245++) {	// L547
            for (int v246 = 0; v246 < 2; v246++) {	// L548
              for (int v247 = 0; v247 < 2; v247++) {	// L549
                for (int v248 = 0; v248 < 2; v248++) {	// L550
                  for (int v249 = 0; v249 < 2; v249++) {	// L551
                    for (int v250 = 0; v250 < 2; v250++) {	// L552
                      for (int v251 = 0; v251 < 2; v251++) {	// L553
                        for (int v252 = 0; v252 < 16; v252++) {	// L554
                          for (int v253 = 0; v253 < 4; v253++) {	// L555
                          #pragma HLS pipeline II=1
                            ap_axiu<128, 0 ,0 ,0> v235_axiu = v235.read();
                            ap_int<128> v254 = v235_axiu.data; //v235                            v254 = v235;	// L556
                            ap_int<128> v255 = v237[(v251 + (v246 * 2))][(v252 + (v247 * 16))][(v253 + (v248 * 4))];	// L557
                            ap_int<128> v256 = v254;
                            ap_int<128> v257 = v255;
                            ap_int<128> v258 = 0;
                            int32_t v259 = v256(31, 0);	// L561
                            int32_t v260 = v257(31, 0);	// L562
                            float v261;
                            union { int32_t from; float to;} _converter_v259_to_v261;
                            _converter_v259_to_v261.from = v259;
                            v261 = _converter_v259_to_v261.to;	// L563
                            float v262;
                            union { int32_t from; float to;} _converter_v260_to_v262;
                            _converter_v260_to_v262.from = v260;
                            v262 = _converter_v260_to_v262.to;	// L564
                            float v263 = v261 + v262;	// L565
                            int32_t v264;
                            union { float from; int32_t to;} _converter_v263_to_v264;
                            _converter_v263_to_v264.from = v263;
                            v264 = _converter_v263_to_v264.to;	// L566
                            v258(31, 0) = v264;	// L567
                            int32_t v265 = v256(63, 32);	// L568
                            int32_t v266 = v257(63, 32);	// L569
                            float v267;
                            union { int32_t from; float to;} _converter_v265_to_v267;
                            _converter_v265_to_v267.from = v265;
                            v267 = _converter_v265_to_v267.to;	// L570
                            float v268;
                            union { int32_t from; float to;} _converter_v266_to_v268;
                            _converter_v266_to_v268.from = v266;
                            v268 = _converter_v266_to_v268.to;	// L571
                            float v269 = v267 + v268;	// L572
                            int32_t v270;
                            union { float from; int32_t to;} _converter_v269_to_v270;
                            _converter_v269_to_v270.from = v269;
                            v270 = _converter_v269_to_v270.to;	// L573
                            v258(63, 32) = v270;	// L574
                            int32_t v271 = v256(95, 64);	// L575
                            int32_t v272 = v257(95, 64);	// L576
                            float v273;
                            union { int32_t from; float to;} _converter_v271_to_v273;
                            _converter_v271_to_v273.from = v271;
                            v273 = _converter_v271_to_v273.to;	// L577
                            float v274;
                            union { int32_t from; float to;} _converter_v272_to_v274;
                            _converter_v272_to_v274.from = v272;
                            v274 = _converter_v272_to_v274.to;	// L578
                            float v275 = v273 + v274;	// L579
                            int32_t v276;
                            union { float from; int32_t to;} _converter_v275_to_v276;
                            _converter_v275_to_v276.from = v275;
                            v276 = _converter_v275_to_v276.to;	// L580
                            v258(95, 64) = v276;	// L581
                            int32_t v277 = v256(127, 96);	// L582
                            int32_t v278 = v257(127, 96);	// L583
                            float v279;
                            union { int32_t from; float to;} _converter_v277_to_v279;
                            _converter_v277_to_v279.from = v277;
                            v279 = _converter_v277_to_v279.to;	// L584
                            float v280;
                            union { int32_t from; float to;} _converter_v278_to_v280;
                            _converter_v278_to_v280.from = v278;
                            v280 = _converter_v278_to_v280.to;	// L585
                            float v281 = v279 + v280;	// L586
                            int32_t v282;
                            union { float from; int32_t to;} _converter_v281_to_v282;
                            _converter_v281_to_v282.from = v281;
                            v282 = _converter_v281_to_v282.to;	// L587
                            v258(127, 96) = v282;	// L588
                            ap_int<128> v283 = v258;
                            v237[(v251 + (v246 * 2))][(v252 + (v247 * 16))][(v253 + (v248 * 4))] = v283;	// L590
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            for (int v284 = 0; v284 < 2; v284++) {	// L599
              for (int v285 = 0; v285 < 2; v285++) {	// L600
                for (int v286 = 0; v286 < 2; v286++) {	// L601
                  for (int v287 = 0; v287 < 16; v287++) {	// L602
                    for (int v288 = 0; v288 < 2; v288++) {	// L603
                      for (int v289 = 0; v289 < 4; v289++) {	// L604
                      #pragma HLS pipeline II=1
                        ap_int<128> v290 = v237[(v286 + (v284 * 2))][(v287 + (v285 * 16))][(v289 + (v288 * 4))];	// L605
                        v236.write(v290); //v236                        v236 = v290;	// L606
                        v237[(v286 + (v284 * 2))][(v287 + (v285 * 16))][(v289 + (v288 * 4))] = 0;	// L607
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
  receive2<0>(v291, v292);	// L622
  receive2<1>(v293, v294);	// L623
  receive2<2>(v295, v296);	// L624
  receive2<3>(v297, v298);	// L625
}

template<int NC>
void store0_0(
  hls::stream< ap_int<128> > &v299 /* v299[1] */,
  hls::stream< ap_int<512> > &v300 /* v300[1] */
){
  #pragma HLS inline OFF
  for (int v301 = 0; v301 < 2; v301++) {	// L630
    for (int v302 = 0; v302 < 2; v302++) {	// L631
      for (int v303 = 0; v303 < 2; v303++) {	// L632
        for (int v304 = 0; v304 < 2; v304++) {	// L633
          for (int v305 = 0; v305 < 2; v305++) {	// L634
            for (int v306 = 0; v306 < 2; v306++) {	// L635
              for (int v307 = 0; v307 < 2; v307++) {	// L636
                for (int v308 = 0; v308 < 2; v308++) {	// L637
                  for (int v309 = 0; v309 < 16; v309++) {	// L638
                    for (int v310 = 0; v310 < 2; v310++) {	// L639
                      for (int v311 = 0; v311 < 1; v311++) {	// L640
                      #pragma HLS pipeline II=4
                        ap_int<512> v312 = 0;
                        for (int v313 = 0; v313 < 4; v313++) {	// L642
                        #pragma HLS pipeline II=1
                          ap_int<128> v314 = v299.read(); //v299                          v314 = v299;	// L643
                          int v315 = ((v313 * 128) + 127);	// L644
                          int v316 = (v313 * 128);	// L645
                          v312(v315, v316) = v314;	// L646
                        }
                        v300.write(v312); //v300                        v300 = v312;	// L648
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

void store0_0_top(
  hls::stream< ap_int<128> > &v317 /* v317[1] */,
  hls::stream< ap_int<512> > &v318 /* v318[1] */,
  hls::stream< ap_int<128> > &v319 /* v319[1] */,
  hls::stream< ap_int<512> > &v320 /* v320[1] */,
  hls::stream< ap_int<128> > &v321 /* v321[1] */,
  hls::stream< ap_int<512> > &v322 /* v322[1] */,
  hls::stream< ap_int<128> > &v323 /* v323[1] */,
  hls::stream< ap_int<512> > &v324 /* v324[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v317, v318);	// L663
  store0_0<1>(v319, v320);	// L664
  store0_0<2>(v321, v322);	// L665
  store0_0<3>(v323, v324);	// L666
}

template<int NC>
void store0(
  ap_int<512> v325[8][128][8],
  hls::stream< ap_int<512> > &v326 /* v326[1] */,
  hls::stream< ap_int<512> > &v327 /* v327[1] */,
  hls::stream< ap_int<512> > &v328 /* v328[1] */,
  hls::stream< ap_int<512> > &v329 /* v329[1] */
){
  #pragma HLS inline OFF
  for (int v330 = 0; v330 < 2; v330++) {	// L671
    for (int v331 = 0; v331 < 2; v331++) {	// L672
      for (int v332 = 0; v332 < 2; v332++) {	// L673
        for (int v333 = 0; v333 < 2; v333++) {	// L674
          for (int v334 = 0; v334 < 2; v334++) {	// L675
            for (int v335 = 0; v335 < 2; v335++) {	// L676
              for (int v336 = 0; v336 < 2; v336++) {	// L677
                for (int v337 = 0; v337 < 2; v337++) {	// L678
                  for (int v338 = 0; v338 < 16; v338++) {	// L679
                    for (int v339 = 0; v339 < 2; v339++) {	// L680
                      for (int v340 = 0; v340 < 2; v340++) {	// L681
                      #pragma HLS pipeline II=1
                        bool v341 = v340 < 1;	// L682
                        ap_int<512> v342;
                        if (v341) {	// L683
                          ap_int<512> v343 = v327.read(); //v327                          v343 = v327;	// L684
                          v342 = v343;	// L685
                        } else {
                          ap_int<512> v344 = v328.read(); //v328                          v344 = v328;	// L687
                          v342 = v344;	// L688
                        }
                        v325[((v337 + (v335 * 2)) + (v330 * 4))][(((v338 + (v336 * 32)) + (v331 * 64)) + 16)][((v340 + (v339 * 2)) + (v332 * 4))] = v342;	// L690
                      }
                    }
                  }
                }
              }
            }
            for (int v345 = 0; v345 < 2; v345++) {	// L697
              for (int v346 = 0; v346 < 2; v346++) {	// L698
                for (int v347 = 0; v347 < 2; v347++) {	// L699
                  for (int v348 = 0; v348 < 16; v348++) {	// L700
                    for (int v349 = 0; v349 < 2; v349++) {	// L701
                      for (int v350 = 0; v350 < 2; v350++) {	// L702
                      #pragma HLS pipeline II=1
                        bool v351 = v350 < 1;	// L703
                        ap_int<512> v352;
                        if (v351) {	// L704
                          ap_int<512> v353 = v329.read(); //v329                          v353 = v329;	// L705
                          v352 = v353;	// L706
                        } else {
                          ap_int<512> v354 = v326.read(); //v326                          v354 = v326;	// L708
                          v352 = v354;	// L709
                        }
                        v325[((v347 + (v345 * 2)) + (v330 * 4))][((v348 + (v346 * 32)) + (v331 * 64))][((v350 + (v349 * 2)) + (v332 * 4))] = v352;	// L711
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

void store0_top(
  ap_int<512> v355[8][128][8],
  hls::stream< ap_int<512> > &v356 /* v356[1] */,
  hls::stream< ap_int<512> > &v357 /* v357[1] */,
  hls::stream< ap_int<512> > &v358 /* v358[1] */,
  hls::stream< ap_int<512> > &v359 /* v359[1] */
){
  #pragma HLS inline OFF
  store0<0>(v355, v356, v357, v358, v359);	// L726
}

template<int NC>
void load0(
  ap_int<512> v360[8][8][8],
  hls::stream< ap_int<512> > &v361 /* v361[1] */,
  hls::stream< ap_int<512> > &v362 /* v362[1] */
){
  #pragma HLS inline OFF
  for (int v363 = 0; v363 < 2; v363++) {	// L731
    for (int v364 = 0; v364 < 2; v364++) {	// L732
      for (int v365 = 0; v365 < 2; v365++) {	// L733
        for (int v366 = 0; v366 < 2; v366++) {	// L734
          for (int v367 = 0; v367 < 2; v367++) {	// L735
            for (int v368 = 0; v368 < 2; v368++) {	// L736
              for (int v369 = 0; v369 < 2; v369++) {	// L737
                for (int v370 = 0; v370 < 2; v370++) {	// L738
                  for (int v371 = 0; v371 < 2; v371++) {	// L739
                    for (int v372 = 0; v372 < 2; v372++) {	// L740
                      for (int v373 = 0; v373 < 2; v373++) {	// L741
                      #pragma HLS pipeline II=1
                        ap_int<512> v374 = v360[((v370 + (v368 * 2)) + (v363 * 4))][((v371 + (v369 * 2)) + (v366 * 4))][((v373 + (v372 * 2)) + (v367 * 4))];	// L742
                        bool v375 = v373 < 1;	// L743
                        if (v375) {	// L744
                          v361.write(v374); //v361                          v361 = v374;	// L745
                        } else {
                          v362.write(v374); //v362                          v362 = v374;	// L747
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
  ap_int<512> v376[8][8][8],
  hls::stream< ap_int<512> > &v377 /* v377[1] */,
  hls::stream< ap_int<512> > &v378 /* v378[1] */
){
  #pragma HLS inline OFF
  load0<0>(v376, v377, v378);	// L763
}

template<int NC>
void load0_1(
  hls::stream< ap_int<512> > &v379 /* v379[1] */,
  hls::stream< ap_int<128> > &v380 /* v380[1] */
){
  #pragma HLS inline OFF
  for (int v381 = 0; v381 < 2; v381++) {	// L767
    for (int v382 = 0; v382 < 2; v382++) {	// L768
      for (int v383 = 0; v383 < 2; v383++) {	// L769
        for (int v384 = 0; v384 < 2; v384++) {	// L770
          for (int v385 = 0; v385 < 2; v385++) {	// L771
            for (int v386 = 0; v386 < 2; v386++) {	// L772
              for (int v387 = 0; v387 < 2; v387++) {	// L773
                for (int v388 = 0; v388 < 2; v388++) {	// L774
                  for (int v389 = 0; v389 < 2; v389++) {	// L775
                    for (int v390 = 0; v390 < 2; v390++) {	// L776
                      for (int v391 = 0; v391 < 1; v391++) {	// L777
                      #pragma HLS pipeline II=4
                        ap_int<512> v392 = v379.read(); //v379                        v392 = v379;	// L778
                        for (int v393 = 0; v393 < 4; v393++) {	// L779
                        #pragma HLS pipeline II=1
                          int v394 = ((v393 * 128) + 127);	// L780
                          int v395 = (v393 * 128);	// L781
                          ap_int<128> v396 = v392(v394, v395);	// L782
                          v380.write(v396); //v380                          v380 = v396;	// L783
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
  hls::stream< ap_int<512> > &v397 /* v397[1] */,
  hls::stream< ap_int<128> > &v398 /* v398[1] */,
  hls::stream< ap_int<512> > &v399 /* v399[1] */,
  hls::stream< ap_int<128> > &v400 /* v400[1] */
){
  #pragma HLS inline OFF
  load0_1<0>(v397, v398);	// L799
  load0_1<1>(v399, v400);	// L800
}

template<int NC>
void load1(
  ap_int<512> v401[8][8],
  hls::stream< ap_int<512> > &v402 /* v402[1] */,
  hls::stream< ap_int<512> > &v403 /* v403[1] */
){
  #pragma HLS inline OFF
  for (int v404 = 0; v404 < 2; v404++) {	// L805
    for (int v405 = 0; v405 < 2; v405++) {	// L806
      for (int v406 = 0; v406 < 2; v406++) {	// L807
        for (int v407 = 0; v407 < 2; v407++) {	// L808
          for (int v408 = 0; v408 < 2; v408++) {	// L809
            for (int v409 = 0; v409 < 2; v409++) {	// L810
              for (int v410 = 0; v410 < 2; v410++) {	// L811
                for (int v411 = 0; v411 < 2; v411++) {	// L812
                  for (int v412 = 0; v412 < 2; v412++) {	// L813
                  #pragma HLS pipeline II=1
                    ap_int<512> v413 = v401[((v410 + (v409 * 2)) + (v407 * 4))][((v412 + (v411 * 2)) + (v405 * 4))];	// L814
                    bool v414 = v412 < 1;	// L815
                    if (v414) {	// L816
                      v403.write(v413); //v403                      v403 = v413;	// L817
                    } else {
                      v402.write(v413); //v402                      v402 = v413;	// L819
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
  ap_int<512> v415[8][8],
  hls::stream< ap_int<512> > &v416 /* v416[1] */,
  hls::stream< ap_int<512> > &v417 /* v417[1] */
){
  #pragma HLS inline OFF
  load1<0>(v415, v416, v417);	// L833
}

template<int NC>
void load1_1(
  hls::stream< ap_int<512> > &v418 /* v418[1] */,
  hls::stream< ap_int<128> > &v419 /* v419[1] */
){
  #pragma HLS inline OFF
  for (int v420 = 0; v420 < 2; v420++) {	// L837
    for (int v421 = 0; v421 < 2; v421++) {	// L838
      for (int v422 = 0; v422 < 2; v422++) {	// L839
        for (int v423 = 0; v423 < 2; v423++) {	// L840
          for (int v424 = 0; v424 < 2; v424++) {	// L841
            for (int v425 = 0; v425 < 2; v425++) {	// L842
              for (int v426 = 0; v426 < 2; v426++) {	// L843
                for (int v427 = 0; v427 < 2; v427++) {	// L844
                  for (int v428 = 0; v428 < 1; v428++) {	// L845
                  #pragma HLS pipeline II=4
                    ap_int<512> v429 = v418.read(); //v418                    v429 = v418;	// L846
                    for (int v430 = 0; v430 < 4; v430++) {	// L847
                    #pragma HLS pipeline II=1
                      int v431 = ((v430 * 128) + 127);	// L848
                      int v432 = (v430 * 128);	// L849
                      ap_int<128> v433 = v429(v431, v432);	// L850
                      v419.write(v433); //v419                      v419 = v433;	// L851
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
  hls::stream< ap_int<512> > &v434 /* v434[1] */,
  hls::stream< ap_int<128> > &v435 /* v435[1] */,
  hls::stream< ap_int<512> > &v436 /* v436[1] */,
  hls::stream< ap_int<128> > &v437 /* v437[1] */
){
  #pragma HLS inline OFF
  load1_1<0>(v434, v435);	// L865
  load1_1<1>(v436, v437);	// L866
}

void ttmc_pl(
  ap_int<512> v438[8][8][8],
  ap_int<512> v439[8][8],
  ap_int<512> v440[128][8],
  ap_int<512> v441[8][128][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v442 /* v442[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v443 /* v443[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v444 /* v444[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v445 /* v445[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v446 /* v446[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v447 /* v447[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v448 /* v448[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v449 /* v449[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v450 /* v450[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v451 /* v451[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v452 /* v452[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v453 /* v453[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v454 /* v454[1] */;	// L871
  hls::stream< ap_int<128> > v455 /* v455[1] */;	// L872
  hls::stream< ap_int<128> > v456 /* v456[1] */;	// L873
  hls::stream< ap_int<128> > v457 /* v457[1] */;	// L874
  hls::stream< ap_int<128> > v458 /* v458[1] */;	// L875
  hls::stream< ap_int<128> > v459 /* v459[1] */;	// L876
  hls::stream< ap_int<128> > v460 /* v460[1] */;	// L877
  hls::stream< ap_int<128> > v461 /* v461[1] */;	// L878
  hls::stream< ap_int<128> > v462 /* v462[1] */;	// L879
  hls::stream< ap_int<128> > v463 /* v463[1] */;	// L880
  hls::stream< ap_int<128> > v464 /* v464[1] */;	// L881
  hls::stream< ap_int<128> > v465 /* v465[1] */;	// L882
  ap_int<128> v466[4][32][8];	// L883
  #pragma HLS bind_storage variable=v466 type=ram_s2p impl=bram
  for (int v467 = 0; v467 < 4; v467++) {	// L884
    for (int v468 = 0; v468 < 32; v468++) {	// L885
      for (int v469 = 0; v469 < 8; v469++) {	// L886
      #pragma HLS pipeline II=1
        v466[v467][v468][v469] = 0;	// L887
      }
    }
  }
  ap_int<128> v470[4][32][8];	// L891
  #pragma HLS bind_storage variable=v470 type=ram_s2p impl=bram
  for (int v471 = 0; v471 < 4; v471++) {	// L892
    for (int v472 = 0; v472 < 32; v472++) {	// L893
      for (int v473 = 0; v473 < 8; v473++) {	// L894
      #pragma HLS pipeline II=1
        v470[v471][v472][v473] = 0;	// L895
      }
    }
  }
  ap_int<128> v474[4][32][8];	// L899
  #pragma HLS bind_storage variable=v474 type=ram_s2p impl=bram
  for (int v475 = 0; v475 < 4; v475++) {	// L900
    for (int v476 = 0; v476 < 32; v476++) {	// L901
      for (int v477 = 0; v477 < 8; v477++) {	// L902
      #pragma HLS pipeline II=1
        v474[v475][v476][v477] = 0;	// L903
      }
    }
  }
  ap_int<128> v478[4][32][8];	// L907
  #pragma HLS bind_storage variable=v478 type=ram_s2p impl=bram
  for (int v479 = 0; v479 < 4; v479++) {	// L908
    for (int v480 = 0; v480 < 32; v480++) {	// L909
      for (int v481 = 0; v481 < 8; v481++) {	// L910
      #pragma HLS pipeline II=1
        v478[v479][v480][v481] = 0;	// L911
      }
    }
  }
  hls::stream< ap_int<512> > v482 /* v482[1] */;	// L915
  #pragma HLS stream variable=v482 depth=1
  hls::stream< ap_int<512> > v483 /* v483[1] */;	// L916
  #pragma HLS stream variable=v483 depth=1
  hls::stream< ap_int<512> > v484 /* v484[1] */;	// L917
  #pragma HLS stream variable=v484 depth=1
  hls::stream< ap_int<512> > v485 /* v485[1] */;	// L918
  #pragma HLS stream variable=v485 depth=1
  hls::stream< ap_int<512> > v486 /* v486[1] */;	// L919
  #pragma HLS stream variable=v486 depth=1
  hls::stream< ap_int<512> > v487 /* v487[1] */;	// L920
  #pragma HLS stream variable=v487 depth=1
  hls::stream< ap_int<512> > v488 /* v488[1] */;	// L921
  #pragma HLS stream variable=v488 depth=1
  hls::stream< ap_int<512> > v489 /* v489[1] */;	// L922
  #pragma HLS stream variable=v489 depth=1
  hls::stream< ap_int<512> > v490 /* v490[1] */;	// L923
  #pragma HLS stream variable=v490 depth=1
  hls::stream< ap_int<512> > v491 /* v491[1] */;	// L924
  #pragma HLS stream variable=v491 depth=1
  hls::stream< ap_int<512> > v492 /* v492[1] */;	// L925
  #pragma HLS stream variable=v492 depth=1
  hls::stream< ap_int<512> > v493 /* v493[1] */;	// L926
  #pragma HLS stream variable=v493 depth=1
  send3_top(v451, v462, v448, v465);	// L927
  load2_top(v440, v484, v485, v483, v482);	// L928
  load2_3_top(v485, v463, v484, v461, v483, v460, v482, v459);	// L929
  send5_top(v450, v460, v443, v459, v452, v461, v447, v463);	// L930
  send1_top(v444, v464, v449, v458);	// L931
  receive2_top(v445, v456, v442, v454, v453, v457, v446, v455);	// L932
  store0_0_top(v454, v486, v455, v487, v456, v488, v457, v489);	// L933
  store0_top(v441, v487, v488, v489, v486);	// L934
  load0_top(v438, v491, v490);	// L935
  load0_1_top(v491, v465, v490, v462);	// L936
  load1_top(v439, v492, v493);	// L937
  load1_1_top(v493, v464, v492, v458);	// L938
}

void top(
  ap_int<512> v494[8][8][8],
  ap_int<512> v495[8][8],
  ap_int<512> v496[128][8],
  ap_int<512> v497[8][128][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v498 /* v498[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v499 /* v499[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v500 /* v500[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v501 /* v501[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v502 /* v502[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v503 /* v503[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v504 /* v504[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v505 /* v505[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v506 /* v506[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v507 /* v507[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v508 /* v508[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v509 /* v509[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v494
  #pragma HLS interface s_axilite bundle=control port=v494
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v495
  #pragma HLS interface s_axilite bundle=control port=v495
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v496
  #pragma HLS interface s_axilite bundle=control port=v496
  #pragma HLS interface m_axi offset=slave bundle=gmem3 port=v497
  #pragma HLS interface s_axilite bundle=control port=v497
  #pragma HLS interface axis port=v498
  #pragma HLS interface axis port=v499
  #pragma HLS interface axis port=v500
  #pragma HLS interface axis port=v501
  #pragma HLS interface axis port=v502
  #pragma HLS interface axis port=v503
  #pragma HLS interface axis port=v504
  #pragma HLS interface axis port=v505
  #pragma HLS interface axis port=v506
  #pragma HLS interface axis port=v507
  #pragma HLS interface axis port=v508
  #pragma HLS interface axis port=v509

  ttmc_pl(v494, v495, v496, v497, v498, v499, v500, v501, v502, v503, v504, v505, v506, v507, v508, v509);	// L977
}


