Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CA7E11C1
	for <lists+kvm-ppc@lfdr.de>; Wed, 23 Oct 2019 07:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfJWFlf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 23 Oct 2019 01:41:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbfJWFlf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 23 Oct 2019 01:41:35 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9N5aTDT112623
        for <kvm-ppc@vger.kernel.org>; Wed, 23 Oct 2019 01:41:34 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vtgtfr5at-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 23 Oct 2019 01:41:34 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 23 Oct 2019 06:41:31 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 23 Oct 2019 06:41:28 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9N5fQRs18546696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 05:41:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D012A405F;
        Wed, 23 Oct 2019 05:41:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E2C6A405B;
        Wed, 23 Oct 2019 05:41:24 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 23 Oct 2019 05:41:24 +0000 (GMT)
Date:   Wed, 23 Oct 2019 11:11:22 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Bharata B Rao <bharata.rao@gmail.com>, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        paulus@au1.ibm.com, sukadev@linux.vnet.ibm.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 2/8] KVM: PPC: Move pages between normal and secure
 memory
Reply-To: bharata@linux.ibm.com
References: <20190925050649.14926-1-bharata@linux.ibm.com>
 <20190925050649.14926-3-bharata@linux.ibm.com>
 <20191018030049.GA907@oak.ozlabs.ibm.com>
 <CAGZKiBqoxAvix3wrF2wuxTrikVCjY6PzD22pHsasew-F=P3KSg@mail.gmail.com>
 <20191023041754.GA5809@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023041754.GA5809@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19102305-0008-0000-0000-00000325D9B5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102305-0009-0000-0000-00004A4507B7
Message-Id: <20191023054122.GA1295@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-23_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910230055
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Oct 23, 2019 at 03:17:54PM +1100, Paul Mackerras wrote:
> On Tue, Oct 22, 2019 at 11:59:35AM +0530, Bharata B Rao wrote:
> The mapping of pages in userspace memory, and the mapping of userspace
> memory to guest physical space, are two distinct things.  The memslots
> describe the mapping of userspace addresses to guest physical
> addresses, but don't say anything about what is mapped at those
> userspace addresses.  So you can indeed get a page fault on a
> userspace address at the same time that a memslot is being deleted
> (even a memslot that maps that particular userspace address), because
> removing the memslot does not unmap anything from userspace memory,
> it just breaks the association between that userspace memory and guest
> physical memory.  Deleting the memslot does unmap the pages from the
> guest but doesn't unmap them from the userspace process (e.g. QEMU).
> 
> It is an interesting question what the semantics should be when a
> memslot is deleted and there are pages of userspace currently paged
> out to the device (i.e. the ultravisor).  One approach might be to say
> that all those pages have to come back to the host before we finish
> the memslot deletion, but that is probably not necessary; I think we
> could just say that those pages are gone and can be replaced by zero
> pages if they get accessed on the host side.  If userspace then unmaps
> the corresponding region of the userspace memory map, we can then just
> forget all those pages with very little work.

There are 5 scenarios currently where we are replacing the device mappings:

1. Guest reset
2. Memslot free (Memory unplug) (Not present in this version though)
3. Converting secure page to shared page
4. HV touching the secure page
5. H_SVM_INIT_ABORT hcall to abort SVM due to errors when transitioning
   to secure mode (Not present in this version)

In the first 3 cases, we don't need to get the page to HV from
the secure side and hence skip the page out. However currently we do
allocate fresh page and replace the mapping with the new one.
 
> > However if that sounds fragile, may be I can go back to my initial
> > design where we weren't using rmap[] to store device PFNs. That will
> > increase the memory usage but we give us an easy option to have
> > per-guest mutex to protect concurrent page-ins/outs/faults.
> 
> That sounds like it would be the best option, even if only in the
> short term.  At least it would give us a working solution, even if
> it's not the best performing solution.

Sure, will avoid using rmap[] in the next version.

Regards,
Bharata.

