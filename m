Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709D612581E
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Dec 2019 00:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRX6C (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Dec 2019 18:58:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbfLRX6B (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Dec 2019 18:58:01 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBINvuS5092246;
        Wed, 18 Dec 2019 18:57:56 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wyt31ejtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 18:57:56 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBINv0E6022240;
        Wed, 18 Dec 2019 23:57:55 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 2wvqc6hmd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 23:57:55 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBINvtGx50921966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:57:55 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54562112062;
        Wed, 18 Dec 2019 23:57:55 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3898E112061;
        Wed, 18 Dec 2019 23:57:55 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.70.94.45])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 23:57:55 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 921DF2E0ED7; Wed, 18 Dec 2019 15:57:53 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:57:53 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, linuxram@us.ibm.com,
        bauerman@linux.ibm.com, andmike@linux.ibm.com,
        linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc/pseries/svm: Don't access some SPRs
Message-ID: <20191218235753.GA12285@us.ibm.com>
References: <20191218043048.3400-1-sukadev@linux.ibm.com>
 <875zidoqok.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zidoqok.fsf@mpe.ellerman.id.au>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.10.1 (2018-07-13)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=839 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180177
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Michael Ellerman [mpe@ellerman.id.au] wrote:
> 
> eg. here.
> 
> This is the fast path of context switch.
> 
> That expands to:
> 
> 	if (!(mfmsr() & MSR_S))
> 		asm volatile("mfspr %0, SPRN_BESCR" : "=r" (rval));
> 	if (!(mfmsr() & MSR_S))
> 		asm volatile("mfspr %0, SPRN_EBBHR" : "=r" (rval));
> 	if (!(mfmsr() & MSR_S))
> 		asm volatile("mfspr %0, SPRN_EBBRR" : "=r" (rval));
> 

Yes, should have optimized this at least :-)
> 
> If the Ultravisor is going to disable EBB and BHRB then we need new
> CPU_FTR bits for those, and the code that accesses those registers
> needs to be put behind cpu_has_feature(EBB) etc.

Will try the cpu_has_feature(). Would it be ok to use a single feature
bit, like UV or make it per-register group as that could need more
feature bits?

Thanks,

Sukadev
