Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EBE1BD0B
	for <lists+kvm-ppc@lfdr.de>; Mon, 13 May 2019 20:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfEMSOU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 13 May 2019 14:14:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbfEMSOT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 13 May 2019 14:14:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4DI84Li007143
        for <kvm-ppc@vger.kernel.org>; Mon, 13 May 2019 14:14:18 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sfbjfna7k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 13 May 2019 14:14:18 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <farosas@linux.ibm.com>;
        Mon, 13 May 2019 19:14:17 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 13 May 2019 19:14:14 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4DIEDW034734210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 18:14:13 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70D56AE067;
        Mon, 13 May 2019 18:14:13 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79231AE060;
        Mon, 13 May 2019 18:14:12 +0000 (GMT)
Received: from localhost (unknown [9.85.195.195])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 13 May 2019 18:14:12 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org
Subject: Re: KVM: Book3S PR: unbreaking software breakpoints
In-Reply-To: <e84fd80c-d6a6-8f19-a4e1-ed309fa68aa9@ilande.co.uk>
References: <e84fd80c-d6a6-8f19-a4e1-ed309fa68aa9@ilande.co.uk>
Date:   Mon, 13 May 2019 15:14:09 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
x-cbid: 19051318-0064-0000-0000-000003DDC310
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011093; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01202825; UDB=6.00631313; IPR=6.00983741;
 MB=3.00026868; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-13 18:14:16
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051318-0065-0000-0000-00003D74BF3D
Message-Id: <87zhnq1atq.fsf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-13_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=611 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905130124
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk> writes:

> For comparison both booke.c and e500_emulate.c set debug.arch.status = 0 for software
> breakpoints, whereas both book3s_hv.c and book3s_pr.c do not. Given that emulate.c
> contains shared code for handling software breakpoints, would the following simple
> patch suffice?
>
>
> diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
> index 9f5b8c01c4e1..e77becaad5dd 100644
> --- a/arch/powerpc/kvm/emulate.c
> +++ b/arch/powerpc/kvm/emulate.c
> @@ -282,6 +282,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct
> kvm_vcpu *vcpu)
>                  */
>                 if (inst == KVMPPC_INST_SW_BREAKPOINT) {
>                         run->exit_reason = KVM_EXIT_DEBUG;
> +                       run->debug.arch.status = 0;
>                         run->debug.arch.address = kvmppc_get_pc(vcpu);
>                         emulated = EMULATE_EXIT_USER;
>                         advance = 0;

This looks reasonable to me.

>
>
> ATB,
>
> Mark.

