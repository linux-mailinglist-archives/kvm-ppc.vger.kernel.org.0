Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF80F0F1D
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 07:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfKFGpz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 01:45:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725913AbfKFGpy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 6 Nov 2019 01:45:54 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA66gY6Z106961
        for <kvm-ppc@vger.kernel.org>; Wed, 6 Nov 2019 01:45:53 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w3q8ekapq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 06 Nov 2019 01:45:53 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 6 Nov 2019 06:45:51 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 6 Nov 2019 06:45:48 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA66jk0a48365578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 06:45:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B7E552054;
        Wed,  6 Nov 2019 06:45:46 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.101])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 92CD952052;
        Wed,  6 Nov 2019 06:45:44 +0000 (GMT)
Date:   Wed, 6 Nov 2019 12:15:42 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 1/8] mm: ksm: Export ksm_madvise()
Reply-To: bharata@linux.ibm.com
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-2-bharata@linux.ibm.com>
 <20191106043329.GB12069@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106043329.GB12069@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19110606-0016-0000-0000-000002C123B8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110606-0017-0000-0000-000033229DDB
Message-Id: <20191106064542.GB21634@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=722 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911060070
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Nov 06, 2019 at 03:33:29PM +1100, Paul Mackerras wrote:
> On Mon, Nov 04, 2019 at 09:47:53AM +0530, Bharata B Rao wrote:
> > KVM PPC module needs ksm_madvise() for supporting secure guests.
> > Guest pages that become secure are represented as device private
> > pages in the host. Such pages shouldn't participate in KSM merging.
> 
> If we don't do the ksm_madvise call, then as far as I can tell, it
> should all still work correctly, but we might have KSM pulling pages
> in unnecessarily, causing a reduction in performance.  Is that right?

I thought so too. When KSM tries to merge a secure page, it should
cause a fault resulting in page-out the secure page. However I see
the below crash when KSM is enabled and KSM scan tries to kmap and
memcmp the device private page.

BUG: Unable to handle kernel data access at 0xc007fffe00010000
Faulting instruction address: 0xc0000000000ab5a0
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
Modules linked in:
CPU: 0 PID: 22 Comm: ksmd Not tainted 5.4.0-rc2-00026-g2249c0ae4a53-dirty #376
NIP:  c0000000000ab5a0 LR: c0000000003d7c3c CTR: 0000000000000004
REGS: c0000001c85d79b0 TRAP: 0300   Not tainted  (5.4.0-rc2-00026-g2249c0ae4a53-dirty)
MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002242  XER: 20040000
CFAR: c0000000000ab3d0 DAR: c007fffe00010000 DSISR: 40000000 IRQMASK: 0 
GPR00: 0000000000000004 c0000001c85d7c40 c0000000018ce000 c0000001c3880000 
GPR04: c007fffe00010000 0000000000010000 0000000000000000 ffffffffffffffff 
GPR08: c000000001992298 0000603820002138 ffffffffffffffff ffffffff00003a69 
GPR12: 0000000024002242 c000000002550000 c0000001c8700000 c00000000179b728 
GPR16: c00c01ffff800040 c00000000179b5b8 c00c00000070e200 ffffffffffffffff 
GPR20: 0000000000000000 0000000000000000 fffffffffffff000 c00000000179b648 
GPR24: c0000000024464a0 c00000000249f568 c000000001118918 0000000000000000 
GPR28: c0000001c804c590 c00000000249f518 0000000000000000 c0000001c8700000 
NIP [c0000000000ab5a0] memcmp+0x320/0x6a0
LR [c0000000003d7c3c] memcmp_pages+0x8c/0xe0
Call Trace:
[c0000001c85d7c40] [c0000001c804c590] 0xc0000001c804c590 (unreliable)
[c0000001c85d7c70] [c0000000004591d0] ksm_scan_thread+0x960/0x21b0
[c0000001c85d7db0] [c0000000001bf328] kthread+0x198/0x1a0
[c0000001c85d7e20] [c00000000000bfbc] ret_from_kernel_thread+0x5c/0x80
Instruction dump:
ebc1fff0 eba1ffe8 eb81ffe0 eb61ffd8 4e800020 38600001 4d810020 3860ffff 
4e800020 38000004 7c0903a6 7d201c28 <7d402428> 7c295040 38630008 38840008 

In anycase, we wouldn't want secure guests pages to be pulled out due
to KSM, hence disabled merging.

Regards,
Bharata.

