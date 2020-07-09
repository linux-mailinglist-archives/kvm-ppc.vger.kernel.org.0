Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89B621AAC6
	for <lists+kvm-ppc@lfdr.de>; Fri, 10 Jul 2020 00:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGIWqe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Jul 2020 18:46:34 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39451 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbgGIWqd (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 9 Jul 2020 18:46:33 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4B2rrR63kHz9sTC; Fri, 10 Jul 2020 08:46:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1594334791; bh=pdNKWfE600pEE+omT2Bwn+T1+sHVHVbJFq5XeBgwg4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JjZENyCp7n41llLYcLONiJryUzMRzmGbKvwLsbbLG2liDNFX6osNPXIara4KWXPX9
         4wDznTMxigHGGfp6eSQSESTUX1LSLbALSOBv30/ZhvXURldmLOESYg3jB6nFq3eQlM
         N4syhRzOOfHWwoA8EiHoHl4HD/f2IOGLpJ/6j2v815Lrcm4Y9YDtGv4CZg89xsTw5L
         l/HUdhuZGB+yKronyHBvllTh0pOnPlV6NquBy64GgGNmKJ7jKqwgRPUJTM+abi5DMa
         0T83+YpOIgODfZV31HwumcUsTm/xEbo1F/zgQi6NIDw4p28O9YoHNOh92TFIpznR9P
         LIsylF8co/Otg==
Date:   Fri, 10 Jul 2020 08:46:27 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Cameron Kaiser <spectre@floodgap.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] powerpc/64s: remove PROT_SAO support
Message-ID: <20200709224627.GA3090980@thinks.paulus.ozlabs.org>
References: <1594288843.m3s9igh1hu.astroid@bobo.none>
 <202007091516.069FGCsT23462070@floodgap.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007091516.069FGCsT23462070@floodgap.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 09, 2020 at 08:16:12AM -0700, Cameron Kaiser wrote:
> > It would probably be better to disallow SAO on all machines than have
> > it available on some hosts and not others.  (Yes I know there is a
> > check on CPU_FTR_ARCH_206 in there, but that has been a no-op since we
> > removed the PPC970 KVM support.)
> 
> May I ask a very stupid question here -- is that meant to imply KVM
> cannot emulate a 970, or that KVM (at least HV, anyway) won't work on a 970?

The PVR is able to be accessed from supervisor mode in the Power ISA,
which means that a guest under KVM-HV always sees the real PVR of the
CPU; it can't be spoofed by KVM.  So for the first half of your
question, about emulating a 970, the answer is "no" or at least "not
completely".  (KVM-PR can of course make the machine look like
anything you want, pretty much, at the expense of lower performance.)

What I was referring to in my original message is that we used to be
able to run KVM-HV on a PPC970 as a host, and we took that out.  So
the answer to the second half of your question is yes.

Paul.
