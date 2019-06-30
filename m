Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60085AF71
	for <lists+kvm-ppc@lfdr.de>; Sun, 30 Jun 2019 10:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF3Ihj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 30 Jun 2019 04:37:39 -0400
Received: from ozlabs.org ([203.11.71.1]:33555 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbfF3Ihf (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 30 Jun 2019 04:37:35 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45c3lx4g6Kz9sNt; Sun, 30 Jun 2019 18:37:33 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 869537709ebf1dc865e75c3fc97b23f8acf37c16
X-Patchwork-Hint: ignore
In-Reply-To: <20190620014651.7645-2-sjitindarsingh@gmail.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     clg@kaod.org, kvm-ppc@vger.kernel.org, sjitindarsingh@gmail.com
Subject: Re: [PATCH 2/3] KVM: PPC: Book3S HV: Signed extend decrementer value if not using large decr
Message-Id: <45c3lx4g6Kz9sNt@ozlabs.org>
Date:   Sun, 30 Jun 2019 18:37:33 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2019-06-20 at 01:46:50 UTC, Suraj Jitindar Singh wrote:
> On POWER9 the decrementer can operate in large decrementer mode where
> the decrementer is 56 bits and signed extended to 64 bits. When not
> operating in this mode the decrementer behaves as a 32 bit decrementer
> which is NOT signed extended (as on POWER8).
> 
> Currently when reading a guest decrementer value we don't take into
> account whether the large decrementer is enabled or not, and this means
> the value will be incorrect when the guest is not using the large
> decrementer. Fix this by sign extending the value read when the guest
> isn't using the large decrementer.
> 
> Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Tested-by: Laurent Vivier <lvivier@redhat.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/869537709ebf1dc865e75c3fc97b23f8acf37c16

cheers
