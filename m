Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C531E3D79
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 May 2020 11:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgE0JXX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 May 2020 05:23:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728195AbgE0JXX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 May 2020 05:23:23 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04R92xpO179567;
        Wed, 27 May 2020 05:23:06 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316x5ead1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 05:23:06 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04R9LuQd010780;
        Wed, 27 May 2020 09:23:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 316uf8k3rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 09:23:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04R9N1AM8519960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 09:23:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3774E4C04A;
        Wed, 27 May 2020 09:23:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B609F4C04E;
        Wed, 27 May 2020 09:23:00 +0000 (GMT)
Received: from pomme.local (unknown [9.145.46.42])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 May 2020 09:23:00 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: relax check on H_SVM_INIT_ABORT
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, groug@kaod.org, mpe@ellerman.id.au,
        sukadev@linux.ibm.com, linuxram@us.ibm.com
References: <20200520193259.0b66db32@bahia.lan>
 <20200520174308.77820-1-ldufour@linux.ibm.com>
 <20200527041649.GD293451@thinks.paulus.ozlabs.org>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <6bf0ada4-7386-d301-beb0-7e25ac94b0fa@linux.ibm.com>
Date:   Wed, 27 May 2020 11:23:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527041649.GD293451@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-26,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=942 malwarescore=0
 clxscore=1011 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270068
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Le 27/05/2020 à 06:16, Paul Mackerras a écrit :
> On Wed, May 20, 2020 at 07:43:08PM +0200, Laurent Dufour wrote:
>> The commit 8c47b6ff29e3 ("KVM: PPC: Book3S HV: Check caller of H_SVM_*
>> Hcalls") added checks of secure bit of SRR1 to filter out the Hcall
>> reserved to the Ultravisor.
>>
>> However, the Hcall H_SVM_INIT_ABORT is made by the Ultravisor passing the
>> context of the VM calling UV_ESM. This allows the Hypervisor to return to
>> the guest without going through the Ultravisor. Thus the Secure bit of SRR1
>> is not set in that particular case.
>>
>> In the case a regular VM is calling H_SVM_INIT_ABORT, this hcall will be
>> filtered out in kvmppc_h_svm_init_abort() because kvm->arch.secure_guest is
>> not set in that case.
>>
>> Fixes: 8c47b6ff29e3 ("KVM: PPC: Book3S HV: Check caller of H_SVM_* Hcalls")
>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> 
> Thanks, applied to my kvm-ppc-next branch.  I expanded the comment in
> the code a little.

Thanks, the comment is more explicit now.

Laurent.
