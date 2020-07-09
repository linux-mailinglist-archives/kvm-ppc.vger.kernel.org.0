Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED4219CFE
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Jul 2020 12:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGIKHR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Jul 2020 06:07:17 -0400
Received: from ozlabs.org ([203.11.71.1]:41883 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgGIKHR (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 9 Jul 2020 06:07:17 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4B2X0M4TJ3z9sSn; Thu,  9 Jul 2020 20:07:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1594289235; bh=BmqapbAxcPw7d2zoeQ9P3HK6zqK/QShIaRzUdVUueHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AxDdTwnPeYgWw58dmekGMZublU5kFAsvyG1J2q1UrG5l3LB6RU5Dr8zF11y+gUAVi
         gE+2SdW/AufV1xj8AblcSs8+G0p50e+iuxLv2e+OvHNV1j/l4TzILFQhxL7KciSoHq
         5l0+IFVtg6iqef7jErk5uEx+9A2q8zhqMuV+6Y741Wl5enlEqAVGqxHp3rzVJEnIkH
         2igv6Sr7VEO4GEF5pnVDRy9Ei8L+BM+IidVzn1ZIrhiDo8H7Yh8vQx9JTS+Fhh5cmJ
         DMovbCbi3FAbc4Hg2iU1il3W031Sw7Kcm/VvM+FvYhqk5egiwgGm+ceftl7w0JSwE5
         hz+T3z6Zu4IQw==
Date:   Thu, 9 Jul 2020 20:07:11 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au
Subject: Re: [RFC PATCH v0 2/2] KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in
 nested KVM
Message-ID: <20200709100711.GA2961345@thinks.paulus.ozlabs.org>
References: <20200703104420.21349-1-bharata@linux.ibm.com>
 <20200703104420.21349-3-bharata@linux.ibm.com>
 <20200709051803.GC2822576@thinks.paulus.ozlabs.org>
 <20200709090851.GD7902@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709090851.GD7902@in.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 09, 2020 at 02:38:51PM +0530, Bharata B Rao wrote:
> On Thu, Jul 09, 2020 at 03:18:03PM +1000, Paul Mackerras wrote:
> > On Fri, Jul 03, 2020 at 04:14:20PM +0530, Bharata B Rao wrote:
> > > In the nested KVM case, replace H_TLB_INVALIDATE by the new hcall
> > > H_RPT_INVALIDATE if available. The availability of this hcall
> > > is determined from "hcall-rpt-invalidate" string in ibm,hypertas-functions
> > > DT property.
> > 
> > What are we going to use when nested KVM supports HPT guests at L2?
> > L1 will need to do partition-scoped tlbies with R=0 via a hypercall,
> > but H_RPT_INVALIDATE says in its name that it only handles radix
> > page tables (i.e. R=1).
> 
> For L2 HPT guests, the old hcall is expected to work after it adds
> support for R=0 case?

That was the plan.

> The new hcall should be advertised via ibm,hypertas-functions only
> for radix guests I suppose.

Well, the L1 hypervisor is a radix guest of L0, so it would have
H_RPT_INVALIDATE available to it?

I guess the question is whether H_RPT_INVALIDATE is supposed to do
everything, that is, radix process-scoped invalidations, radix
partition-scoped invalidations, and HPT partition-scoped
invalidations.  If that is the plan then we should call it something
different.

This patchset seems to imply that H_RPT_INVALIDATE is at least going
to be used for radix partition-scoped invalidations as well as radix
process-scoped invalidations.  If you are thinking that in future when
we need HPT partition-scoped invalidations for a radix L1 hypervisor
running a HPT L2 guest, we are going to define a new hypercall for
that, I suppose that is OK, though it doesn't really seem necessary.

Paul.
