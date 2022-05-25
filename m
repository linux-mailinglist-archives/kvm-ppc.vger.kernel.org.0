Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FC2533D3B
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 May 2022 15:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiEYNIO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 May 2022 09:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiEYNIN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 May 2022 09:08:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93F44BB97
        for <kvm-ppc@vger.kernel.org>; Wed, 25 May 2022 06:08:12 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PBwaAN005218;
        Wed, 25 May 2022 13:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ae0KWr/nEX5BxzbziSDeEoIK7/ruZeeCVMSPMmZqKdo=;
 b=IrnXkxbzEcSdru1yBzilJLDwTccnfTMZlACCXeDlTMyBPOOW7JUgY4xe0PEmYMSyk7eg
 3up3vMLwW1WOkdJk0/KLb4fEtLXT2W6cSHu7Uk6ZvDWDQnGd6XY+UWjbc/3icLlOLXAF
 1+9iMSi+or01YLKkJP/MRTASiczHZlu8ac3PE1K+2xdrh/trAa8xl5GP4QTwSalckOqN
 9yTY0j97ToPJbLVPWPbI7U4IwByeQQJrzlGS3bxT1shBLx5Mr+yned85k8GxQeQBQ/m8
 jKW6eCTsQESRJ32phQXFyhOQX14SQqNbuOFJN0CQ68QN6DTsEzp9mnCC48xtGSFxMbSt CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9m1w9dd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:06 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PD4UJW012565;
        Wed, 25 May 2022 13:08:05 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9m1w9dcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:05 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PD29cn028638;
        Wed, 25 May 2022 13:08:05 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3g93utyktd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:05 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PD846I54198684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 13:08:04 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12153112065;
        Wed, 25 May 2022 13:08:04 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE3FC112061;
        Wed, 25 May 2022 13:08:02 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.160.108.97])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 13:08:02 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH 0/5] KVM: PPC: Book3S HV: Update debug timing code
Date:   Wed, 25 May 2022 10:05:49 -0300
Message-Id: <20220525130554.2614394-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qrPg7K3fdspNE7x980phdO-WCgAyQJ59
X-Proofpoint-ORIG-GUID: nMvFjICgGoUh8IVFaUFkpF_KPZujACxG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=997 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 impostorscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

We have some debug information at /sys/kernel/debug/kvm/<vm>/vcpu#/timings
which shows the time it takes to run various parts of the code.

That infrastructure was written in the P8 timeframe and wasn't updated
along with the guest entry point changes for P9.

Ideally we would be able to just add new/different accounting points
to the code as it changes over time but since the P8 and P9 entry
points are different code paths we first need to separate them from
each other. This series alters KVM Kconfig to make that distinction.

Currently:
CONFIG_KVM_BOOK3S_HV_EXIT_TIMING - timing infrastructure in asm (P8 only)
				   timing infrastructure in C (P9 only)
				   generic timing variables (P8/P9)
				   debugfs code
                                   timing points for P8

After this series:
CONFIG_KVM_BOOK3S_HV_EXIT_TIMING - generic timing variables (P8/P9)
				   debugfs code

CONFIG_KVM_BOOK3S_HV_P8_TIMING - timing infrastructure in asm (P8 only)
			         timing points for P8

CONFIG_KVM_BOOK3S_HV_P9_TIMING - timing infrastructure in C (P9 only)
			         timing points for P9

The new Kconfig rules are:

a) CONFIG_KVM_BOOK3S_HV_P8_TIMING selects CONFIG_KVM_BOOK3S_HV_EXIT_TIMING,
   resulting in the previous behavior. Tested on P8.

b) CONFIG_KVM_BOOK3S_HV_P9_TIMING selects CONFIG_KVM_BOOK3S_HV_EXIT_TIMING,
   resulting in the new behavior. Tested on P9.

c) CONFIG_KVM_BOOK3S_HV_P8_TIMING and CONFIG_KVM_BOOK3S_HV_P9_TIMING
   are mutually exclusive. If both are set, P9 takes precedence.

Fabiano Rosas (5):
  KVM: PPC: Book3S HV: Fix "rm_exit" entry in debugfs timings
  KVM: PPC: Book3S HV: Add a new config for P8 debug timing
  KVM: PPC: Book3S HV: Decouple the debug timing from the P8 entry path
  KVM: PPC: Book3S HV: Expose timing functions to module code
  KVM: PPC: Book3S HV: Provide more detailed timings for P9 entry path

 arch/powerpc/include/asm/kvm_host.h     | 10 +++++++
 arch/powerpc/kernel/asm-offsets.c       |  2 +-
 arch/powerpc/kvm/Kconfig                | 19 ++++++++++++-
 arch/powerpc/kvm/book3s_hv.c            | 26 ++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.h            | 10 +++++++
 arch/powerpc/kvm/book3s_hv_p9_entry.c   | 36 +++++--------------------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 24 ++++++++---------
 7 files changed, 82 insertions(+), 45 deletions(-)

-- 
2.35.1

