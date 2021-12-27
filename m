Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987A54802C6
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 Dec 2021 18:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhL0R2n (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 27 Dec 2021 12:28:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhL0R2m (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 27 Dec 2021 12:28:42 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BRH6vDJ000541;
        Mon, 27 Dec 2021 17:28:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=JGU8JDr6kWOCicKLZ6qJzpvTiSJ0wxlDTBSy+qRBNHE=;
 b=mRYvKn82ayS3F/QFA30brVziqcT6ugoStUdXgyPp5d0MhXlTosgiqmtaHsDk3jfsEhXa
 dkWSMUcaf7ntt/bcXCZuPnUKSGPCzkgA6LBnYTi2v8WBnkpS/3gCcbLVjzYAqfAeERCp
 lIs9P+tADdOPP+M9jHeylPp4cRl462WHh+E6dtRS3OzwfFBJfX6dpJD4lkzUxfc3lH0M
 p/3FvfC8aFskHxd2O/0NTfNcXR7it/B4gtMpFggZBw+UZa+UpBk2aZP0WNEiVDPt8lKG
 BWJdASqJinW3niRrjmAg/gEGei+WxvybBdYtAN344TC1mdpBJ6+B6Tr9h0G3CILUBIqd 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7f1nbck1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 17:28:33 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BRHNtmC029940;
        Mon, 27 Dec 2021 17:28:32 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7f1nbcjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 17:28:32 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BRHRJq8015131;
        Mon, 27 Dec 2021 17:28:31 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3d5tx9w1vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 17:28:31 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BRHSUWN27722138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Dec 2021 17:28:30 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAB90BE053;
        Mon, 27 Dec 2021 17:28:30 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A190BE054;
        Mon, 27 Dec 2021 17:28:30 +0000 (GMT)
Received: from localhost (unknown [9.211.154.52])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Dec 2021 17:28:29 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
Subject: Re: [PATCH 2/3] KVM: PPC: Fix vmx/vsx mixup in mmio emulation
In-Reply-To: <1640427087.r4g49fcnps.astroid@bobo.none>
References: <20211223211528.3560711-1-farosas@linux.ibm.com>
 <20211223211528.3560711-3-farosas@linux.ibm.com>
 <1640427087.r4g49fcnps.astroid@bobo.none>
Date:   Mon, 27 Dec 2021 14:28:28 -0300
Message-ID: <87zgomq7nn.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YBkSvNSVbboZS5X1OyoTp4wol48Z0iek
X-Proofpoint-ORIG-GUID: jX1TnVkGMiOE6qTWdtD5RPjk3EzZSZ_Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-27_09,2021-12-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=819 clxscore=1015 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112270083
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Excerpts from Fabiano Rosas's message of December 24, 2021 7:15 am:
>> The MMIO emulation code for vector instructions is duplicated between
>> VSX and VMX. When emulating VMX we should check the VMX copy size
>> instead of the VSX one.
>> 
>> Fixes: acc9eb9305fe ("KVM: PPC: Reimplement LOAD_VMX/STORE_VMX instruction ...")
>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>
> Good catch. AFAIKS handle_vmx_store needs the same treatment? If you
> agree then

Half the bug now, half the bug next year... haha I'll send a v2.

aside:
All this duplication is kind of annoying. I'm looking into what it would
take to have quadword instruction emulation here as well (Alexey caught
a bug with syskaller) and the code would be really similar. I see that
x86 has a more generic implementation that maybe we could take advantage
of. See "f78146b0f923 (KVM: Fix page-crossing MMIO)"
