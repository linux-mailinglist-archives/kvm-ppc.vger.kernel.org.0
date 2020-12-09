Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0372D3983
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Dec 2020 05:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgLIEQo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 8 Dec 2020 23:16:44 -0500
Received: from ozlabs.org ([203.11.71.1]:48957 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgLIEQo (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 8 Dec 2020 23:16:44 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4CrNyV6X4sz9sWC; Wed,  9 Dec 2020 15:16:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1607487362; bh=jqtZFI7KL7v46Pp3s+SsaUNEfvanCrhY8vPaiiWNGA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gz4ZDnccQU+sPGtfKTwUSUDh7N8XvvpczzIgXv7JISlKiCzQVqCAsPdlSuW+A7Gfq
         z3R4wyUqc6eGJLQBgNIDCiX2+BI9szVsYjR6Os8lqeX9UJKJznIYJWYBf0JPIZnJLC
         KssI9r/eaho7i1UpIa7ghOfnnVWGZyfNgPvwuJXjkKIpM7LFDKwGQMFtcuRD68a/rJ
         Xce8SAKlRLtnF1dthsJO5EC29H3Y95tsH9VFY1OE7fCMLRyJenZI3K7KVUMwQS4FBI
         GG3HUXbionHOVT/NF7hwYoVg8bafbns0Ie8Wmbd+1GYDQx968Qysh4+liKDdnguWJd
         GKRGvDE+l9Yww==
Date:   Wed, 9 Dec 2020 15:15:42 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v1 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE (nested case only)
Message-ID: <20201209041542.GA29825@thinks.paulus.ozlabs.org>
References: <20201019112642.53016-1-bharata@linux.ibm.com>
 <20201019112642.53016-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019112642.53016-2-bharata@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Oct 19, 2020 at 04:56:41PM +0530, Bharata B Rao wrote:
> Implements H_RPT_INVALIDATE hcall and supports only nested case
> currently.
> 
> A KVM capability KVM_CAP_RPT_INVALIDATE is added to indicate the
> support for this hcall.

I have a couple of questions about this patch:

1. Is this something that is useful today, or is it something that may
become useful in the future depending on future product plans?  In
other words, what advantage is there to forcing L2 guests to use this
hcall instead of doing tlbie themselves?

2. Why does it need to be added to the default-enabled hcall list?

There is a concern that if this is enabled by default we could get the
situation where a guest using it gets migrated to a host that doesn't
support it, which would be bad.  That is the reason that all new
things like this are disabled by default and only enabled by userspace
(i.e. QEMU) in situations where we can enforce that it is available on
all hosts to which the VM might be migrated.

Thanks,
Paul.
