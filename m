Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2A6481F2D
	for <lists+kvm-ppc@lfdr.de>; Thu, 30 Dec 2021 19:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbhL3SY1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 30 Dec 2021 13:24:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233228AbhL3SY1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 30 Dec 2021 13:24:27 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BUFfUPM024003;
        Thu, 30 Dec 2021 18:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=YWgRaEd+REMjJpcwUjRw9SyuwqkdBQZTpBdM89u9W9o=;
 b=pIdgM2M6lZu/CdtovOrLDRciPextT/E8T5GHkhX9jYqF8U34y4ULjd85guYnGIWHmMPG
 RGbfqmLW6lyv5icgQueJktjXvCJRgc7sJN9meCyNa2Yu3OMpqnZqJH4M3Qd9fv4a13e9
 v7cqo0ZGP8MMuHIyMLq6SncdMHWs0wiA2XedinYmszwkCmfP/DQj6jRECAEI820IO7Uy
 Bgr/Vu48rtHJEJVt49I9JGIvxqgjkIrH28Q4ntDf3EP3TbFqOpvX7X1MQxBCewvafBZk
 bB0s6svHO7U+1JG7F5ZtW4Tl5mh4Xm5ExX7Xv4VMJrxVbpIdQ783kMIybJpWnvQUbVjA 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d9fmr2bmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 18:24:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BUICXA7013397;
        Thu, 30 Dec 2021 18:24:15 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d9fmr2bm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 18:24:15 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BUIHCOx016233;
        Thu, 30 Dec 2021 18:24:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 3d5txb45c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 18:24:14 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BUIODdG22479280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Dec 2021 18:24:13 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42B64C6062;
        Thu, 30 Dec 2021 18:24:13 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D531C6061;
        Thu, 30 Dec 2021 18:24:12 +0000 (GMT)
Received: from localhost (unknown [9.211.44.182])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Dec 2021 18:24:12 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
Subject: Re: [PATCH 3/3] KVM: PPC: Fix mmio length message
In-Reply-To: <1640427230.38pm5r9iop.astroid@bobo.none>
References: <20211223211528.3560711-1-farosas@linux.ibm.com>
 <20211223211528.3560711-4-farosas@linux.ibm.com>
 <1640427230.38pm5r9iop.astroid@bobo.none>
Date:   Thu, 30 Dec 2021 15:24:10 -0300
Message-ID: <87k0fmdk8l.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1uGL07M_4uGru3WZfmg356fR9qH0iS8R
X-Proofpoint-GUID: QABWd76b-9hV9yV2wWZoSXxlY-I3NdEN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_06,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112300104
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Excerpts from Fabiano Rosas's message of December 24, 2021 7:15 am:
>> We check against 'bytes' but print 'run->mmio.len' which at that point
>> has an old value.
>> 
>> e.g. 16-byte load:
>> 
>> before:
>> __kvmppc_handle_load: bad MMIO length: 8
>> 
>> now:
>> __kvmppc_handle_load: bad MMIO length: 16
>> 
>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>
> This patch fine, but in the case of overflow we continue anyway here.
> Can that overwrite some other memory in the kvm_run struct?

I tested this and QEMU will indeed overwrite the subsequent fields of
kvm_run. A `lq` on this data:

mmio_test_data:
	.long	0xdeadbeef
	.long	0x8badf00d
	.long	0x1337c0de
	.long	0x01abcdef

produces:

__kvmppc_handle_load: bad MMIO length: 16
kvmppc_complete_mmio_load data: 0x8badf00ddeadbeef
bad MMIO length: 322420958          <-- mmio.len got nuked

But then we return from kvmppc_complete_mmio_load without writing to the
registers.

>
> This is familiar, maybe something Alexey has noticed in the past too?
> What was the consensus on fixing it? (at least it should have a comment
> if it's not a problem IMO)

My plan was to just add quadword support. And whatever else might
missing. But I got sidetracked with how to test this so I'm just now
coming back to it.

Perhaps a more immediate fix is needed before that? We could block loads
and stores larger than 8 bytes earlier at kvmppc_emulate_loadstore for
instance.
