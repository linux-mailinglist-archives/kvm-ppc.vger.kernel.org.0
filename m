Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376D63615D5
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Apr 2021 01:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbhDOXKc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Apr 2021 19:10:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236351AbhDOXKb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Apr 2021 19:10:31 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FN4vpQ133241;
        Thu, 15 Apr 2021 19:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=JAg/KgyZ83q3fle9DQxJUiBju8/aygVhBbWdM4vPZNQ=;
 b=cRJIMG7RDNWJj1o2I5lHQgyyLm1IByXGoMj5qU195bH2tGQMjP3KfMqknYxThuSoLN+U
 xcrs0ZOW24XkjzS3dhZKSm7BBKM28uaIxmwGw3EH9ZjuFuTINM0G/kYGh71frCaB9yrB
 oIjWKNbYOzlgV41XvQzOTm4BFdahNSVDgA7IxxFf4uQsMOkljjrkNj1W0CxcpetST2Sy
 3yCA3ucfyT5qftfksjQtv1c3Qezn3yDTg26Qq6+VDrkeIA2JxZDBUC6MvNztr2/w71xM
 AgldRYQacFKks6PdkWReUB9QuD48PU8+bWjtrYhxnw4pVnc0y9MbJvQhzivRKhAI3EYY ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x4dmapp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 19:09:57 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13FN4xro133477;
        Thu, 15 Apr 2021 19:09:57 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x4dmapnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 19:09:57 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13FN2FjQ024482;
        Thu, 15 Apr 2021 23:09:56 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 37xc73s4vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 23:09:56 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13FN9tNt32440806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 23:09:55 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79D81112064;
        Thu, 15 Apr 2021 23:09:55 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64A5E112061;
        Thu, 15 Apr 2021 23:09:53 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.84.45])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 15 Apr 2021 23:09:53 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH v3 0/2] KVM: PPC: Book3S HV: Nested guest HFSCR changes
Date:   Thu, 15 Apr 2021 20:09:46 -0300
Message-Id: <20210415230948.3563415-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: STodYj94V5wbcoeplH65NZF2FKWwGqd7
X-Proofpoint-ORIG-GUID: ez9P1Vb-0LPrIKvBppzfQG_Azb2Sl8Ox
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_10:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=929
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150142
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Applied Nick's suggestions and added a new patch for the Cause bits
issue.

I'm thinking maybe the approach of crashing L1 when L2 tries to access
a facility that L0 has denied is too heavy-handed. But on the other
hand, if L1 were to access the facility itself, the same thing would
happen and L2 runs "inside of L1" in a sense.

Currently, both L0 and L1s handle only msgsndp. All other HV Facility
Unavailable causes are already met with a Program interrupt.

Changes since v2:

- removed the sanitise functions
- moved the entry code into a new load_l2_hv_regs and the exit code
  into the existing save_hv_return_state
- new patch: removes the cause bits when L0 has disabled the
  corresponding facility

v2:

- made the change more generic, not only applies to hfscr anymore;
- sanitisation is now done directly on the vcpu struct, l2_hv is left unchanged;

https://lkml.kernel.org/r/20210406214645.3315819-1-farosas@linux.ibm.com

v1:
https://lkml.kernel.org/r/20210305231055.2913892-1-farosas@linux.ibm.com

Fabiano Rosas (2):
  KVM: PPC: Book3S HV: Sanitise vcpu registers in nested path
  KVM: PPC: Book3S HV: Stop forwarding all HFSCR cause bits to L1

 arch/powerpc/kvm/book3s_hv_nested.c | 72 ++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 21 deletions(-)

--
2.29.2
