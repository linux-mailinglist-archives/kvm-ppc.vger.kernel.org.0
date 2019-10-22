Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F2DFDB4
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Oct 2019 08:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfJVG3s (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Oct 2019 02:29:48 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:47039 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfJVG3r (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Oct 2019 02:29:47 -0400
Received: by mail-ot1-f65.google.com with SMTP id 89so13170354oth.13
        for <kvm-ppc@vger.kernel.org>; Mon, 21 Oct 2019 23:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kVuB3ZdcTD312TKFiKblRZFbqKpk6CiWqdGLygNSyYI=;
        b=Kt8RFytrfhZZoo4M+/oorpPr26q0SJUIGT1ad0V21N9+zN85w4W6+ckVjDTUBlPKem
         9BhJnufmd+S0x/PDNMwU/9jbEGeoBr17AF33tjrcAtsFL8hTKXat7oNMQfpdjaeuF/qK
         A4GWmf0dFMu3BdkLwtFCxcUAxu6Tv/ODrnhUKicGjSnD9EFLEkTj4Cb7PMJBTtKtWfTI
         8ozI+2RNmv2PINYhQrptvvBBrdW6ZxH7hTl6g/CwKdI2C4Ax2BrDfW6DMvfMAR55uNL4
         +J+D5iQNyIyLzsNdds/TaAC6+D3RLo4GiU+GeQkjh+GLv58y/RfXQWDqmX5f4rwzjMJx
         m/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kVuB3ZdcTD312TKFiKblRZFbqKpk6CiWqdGLygNSyYI=;
        b=pna9gQ+CJ5adNen8who+uQ0Pv49Vp8l1PcG8WkpB3YSuTXblr8L0hJQDLfoZPM9937
         XPRCsvwajilwXeLP66nRDWHI9LhiYI9/IdgXOFg8qH2Pjtj+IsBqkMhoNCUsDGdUX5HS
         31ZFieJuVyuQjLptM11FDuDr/91w3gfZDv9lvxtwXQZ0MBuKVE1aEAFGm6I04yl82Px4
         p66gLAL/IK7x778bkcxojinKnzyHhTLd1cX5hPVe3cQytoiPvLb4S3rUPotTMgj+z41U
         9xKbdDrQQbdMKDfT4moTzQSY+wqaA5CX9aWsiZZlPU5mSfGC7WJnsGV1o1rZawtHTjez
         mPMg==
X-Gm-Message-State: APjAAAVjDfrtBuDxBkMgUb46/eqdTnVhdrqzAonahJC2WN/gpAVC9sbg
        0lAfvJqn0gJMnEYRaozDLei1h2+DydW6xz679Ks=
X-Google-Smtp-Source: APXvYqzaxJrbzIMlPV3k+T7wY+FXiNPnEDMD07rPiY7Uh9rrYJMtaW2RPKKderc1uhnmHj42l57t1SwrmQcjoiLDf8M=
X-Received: by 2002:a9d:1a5:: with SMTP id e34mr1442226ote.286.1571725786985;
 Mon, 21 Oct 2019 23:29:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190925050649.14926-1-bharata@linux.ibm.com> <20190925050649.14926-3-bharata@linux.ibm.com>
 <20191018030049.GA907@oak.ozlabs.ibm.com>
In-Reply-To: <20191018030049.GA907@oak.ozlabs.ibm.com>
From:   Bharata B Rao <bharata.rao@gmail.com>
Date:   Tue, 22 Oct 2019 11:59:35 +0530
Message-ID: <CAGZKiBqoxAvix3wrF2wuxTrikVCjY6PzD22pHsasew-F=P3KSg@mail.gmail.com>
Subject: Re: [PATCH v9 2/8] KVM: PPC: Move pages between normal and secure memory
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Bharata B Rao <bharata@linux.ibm.com>, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        paulus@au1.ibm.com, sukadev@linux.vnet.ibm.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Oct 18, 2019 at 8:31 AM Paul Mackerras <paulus@ozlabs.org> wrote:
>
> On Wed, Sep 25, 2019 at 10:36:43AM +0530, Bharata B Rao wrote:
> > Manage migration of pages betwen normal and secure memory of secure
> > guest by implementing H_SVM_PAGE_IN and H_SVM_PAGE_OUT hcalls.
> >
> > H_SVM_PAGE_IN: Move the content of a normal page to secure page
> > H_SVM_PAGE_OUT: Move the content of a secure page to normal page
> >
> > Private ZONE_DEVICE memory equal to the amount of secure memory
> > available in the platform for running secure guests is created.
> > Whenever a page belonging to the guest becomes secure, a page from
> > this private device memory is used to represent and track that secure
> > page on the HV side. The movement of pages between normal and secure
> > memory is done via migrate_vma_pages() using UV_PAGE_IN and
> > UV_PAGE_OUT ucalls.
>
> As we discussed privately, but mentioning it here so there is a
> record:  I am concerned about this structure
>
> > +struct kvmppc_uvmem_page_pvt {
> > +     unsigned long *rmap;
> > +     struct kvm *kvm;
> > +     unsigned long gpa;
> > +};
>
> which keeps a reference to the rmap.  The reference could become stale
> if the memslot is deleted or moved, and nothing in the patch series
> ensures that the stale references are cleaned up.

I will add code to release the device PFNs when memslot goes away. In
fact the early versions of the patchset had this, but it subsequently
got removed.

>
> If it is possible to do without the long-term rmap reference, and
> instead find the rmap via the memslots (with the srcu lock held) each
> time we need the rmap, that would be safer, I think, provided that we
> can sort out the lock ordering issues.

All paths except fault handler access rmap[] under srcu lock. Even in
case of fault handler, for those faults induced by us (shared page
handling, releasing device pfns), we do hold srcu lock. The difficult
case is when we fault due to HV accessing a device page. In this case
we come to fault hanler with mmap_sem already held and are not in a
position to take kvm srcu lock as that would lead to lock order
reversal. Given that we have pages mapped in still, I assume memslot
can't go away while we access rmap[], so think we should be ok here.

However if that sounds fragile, may be I can go back to my initial
design where we weren't using rmap[] to store device PFNs. That will
increase the memory usage but we give us an easy option to have
per-guest mutex to protect concurrent page-ins/outs/faults.

Regards,
Bharata.
-- 
http://raobharata.wordpress.com/
