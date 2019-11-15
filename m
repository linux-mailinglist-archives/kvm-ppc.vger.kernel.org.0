Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB13FDFC5
	for <lists+kvm-ppc@lfdr.de>; Fri, 15 Nov 2019 15:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfKOOKW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 15 Nov 2019 09:10:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727412AbfKOOKW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 15 Nov 2019 09:10:22 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFDuhnK090566
        for <kvm-ppc@vger.kernel.org>; Fri, 15 Nov 2019 09:10:21 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9ntbfnsg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 15 Nov 2019 09:10:20 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Fri, 15 Nov 2019 14:10:16 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 14:10:13 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAFEABpE29098128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 14:10:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1D0352065;
        Fri, 15 Nov 2019 14:10:11 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.38.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 6E1E652051;
        Fri, 15 Nov 2019 14:10:09 +0000 (GMT)
Date:   Fri, 15 Nov 2019 19:40:06 +0530
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
 <20191106064542.GB21634@in.ibm.com>
 <20191107054535.GA2882@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107054535.GA2882@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19111514-0028-0000-0000-000003B72F0A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111514-0029-0000-0000-0000247A40ED
Message-Id: <20191115141006.GA21409@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_04:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 impostorscore=0 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911150126
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Nov 07, 2019 at 04:45:35PM +1100, Paul Mackerras wrote:
> On Wed, Nov 06, 2019 at 12:15:42PM +0530, Bharata B Rao wrote:
> > On Wed, Nov 06, 2019 at 03:33:29PM +1100, Paul Mackerras wrote:
> > > On Mon, Nov 04, 2019 at 09:47:53AM +0530, Bharata B Rao wrote:
> > > > KVM PPC module needs ksm_madvise() for supporting secure guests.
> > > > Guest pages that become secure are represented as device private
> > > > pages in the host. Such pages shouldn't participate in KSM merging.
> > > 
> > > If we don't do the ksm_madvise call, then as far as I can tell, it
> > > should all still work correctly, but we might have KSM pulling pages
> > > in unnecessarily, causing a reduction in performance.  Is that right?
> > 
> > I thought so too. When KSM tries to merge a secure page, it should
> > cause a fault resulting in page-out the secure page. However I see
> > the below crash when KSM is enabled and KSM scan tries to kmap and
> > memcmp the device private page.
> > 
> > BUG: Unable to handle kernel data access at 0xc007fffe00010000
> > Faulting instruction address: 0xc0000000000ab5a0
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
> > Modules linked in:
> > CPU: 0 PID: 22 Comm: ksmd Not tainted 5.4.0-rc2-00026-g2249c0ae4a53-dirty #376
> > NIP:  c0000000000ab5a0 LR: c0000000003d7c3c CTR: 0000000000000004
> > REGS: c0000001c85d79b0 TRAP: 0300   Not tainted  (5.4.0-rc2-00026-g2249c0ae4a53-dirty)
> > MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002242  XER: 20040000
> > CFAR: c0000000000ab3d0 DAR: c007fffe00010000 DSISR: 40000000 IRQMASK: 0 
> > GPR00: 0000000000000004 c0000001c85d7c40 c0000000018ce000 c0000001c3880000 
> > GPR04: c007fffe00010000 0000000000010000 0000000000000000 ffffffffffffffff 
> > GPR08: c000000001992298 0000603820002138 ffffffffffffffff ffffffff00003a69 
> > GPR12: 0000000024002242 c000000002550000 c0000001c8700000 c00000000179b728 
> > GPR16: c00c01ffff800040 c00000000179b5b8 c00c00000070e200 ffffffffffffffff 
> > GPR20: 0000000000000000 0000000000000000 fffffffffffff000 c00000000179b648 
> > GPR24: c0000000024464a0 c00000000249f568 c000000001118918 0000000000000000 
> > GPR28: c0000001c804c590 c00000000249f518 0000000000000000 c0000001c8700000 
> > NIP [c0000000000ab5a0] memcmp+0x320/0x6a0
> > LR [c0000000003d7c3c] memcmp_pages+0x8c/0xe0
> > Call Trace:
> > [c0000001c85d7c40] [c0000001c804c590] 0xc0000001c804c590 (unreliable)
> > [c0000001c85d7c70] [c0000000004591d0] ksm_scan_thread+0x960/0x21b0
> > [c0000001c85d7db0] [c0000000001bf328] kthread+0x198/0x1a0
> > [c0000001c85d7e20] [c00000000000bfbc] ret_from_kernel_thread+0x5c/0x80
> > Instruction dump:
> > ebc1fff0 eba1ffe8 eb81ffe0 eb61ffd8 4e800020 38600001 4d810020 3860ffff 
> > 4e800020 38000004 7c0903a6 7d201c28 <7d402428> 7c295040 38630008 38840008 
> 
> Hmmm, that seems like a bug in the ZONE_DEVICE stuff generally.  All
> that ksm is doing as far as I can see is follow_page() and
> kmap_atomic().  I wonder how many other places in the kernel might
> also be prone to crashing if they try to touch device pages?

In the above shown crash, we don't go via follow_page() and hence
I believe we don't hit the fault path. I see that we come here
after getting the page from get_ksm_page() which returns a device
private page which the subsequent memcmp_pages() does kmap_atomic and
tries to access the address resulting in the above crash.

> 
> > In anycase, we wouldn't want secure guests pages to be pulled out due
> > to KSM, hence disabled merging.
> 
> Sure, I don't disagree with that, but I worry that we are papering
> over a bug here.

Looks like yes. May be someone with better understanding of KSM code
can comment here?

Regards,
Bharata.

