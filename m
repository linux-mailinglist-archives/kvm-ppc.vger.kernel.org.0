Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF155AF70
	for <lists+kvm-ppc@lfdr.de>; Sun, 30 Jun 2019 10:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfF3Ihh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 30 Jun 2019 04:37:37 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34407 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbfF3Ihg (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 30 Jun 2019 04:37:36 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45c3ly4fpfz9sCJ; Sun, 30 Jun 2019 18:37:34 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 3c25ab35fbc8526ac0c9b298e8a78e7ad7a55479
X-Patchwork-Hint: ignore
In-Reply-To: <20190620014651.7645-3-sjitindarsingh@gmail.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     clg@kaod.org, kvm-ppc@vger.kernel.org, sjitindarsingh@gmail.com
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S HV: Clear pending decr exceptions on nested guest entry
Message-Id: <45c3ly4fpfz9sCJ@ozlabs.org>
Date:   Sun, 30 Jun 2019 18:37:34 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2019-06-20 at 01:46:51 UTC, Suraj Jitindar Singh wrote:
> If we enter an L1 guest with a pending decrementer exception then this
> is cleared on guest exit if the guest has writtien a positive value into
> the decrementer (indicating that it handled the decrementer exception)
> since there is no other way to detect that the guest has handled the
> pending exception and that it should be dequeued. In the event that the
> L1 guest tries to run a nested (L2) guest immediately after this and the
> L2 guest decrementer is negative (which is loaded by L1 before making
> the H_ENTER_NESTED hcall), then the pending decrementer exception
> isn't cleared and the L2 entry is blocked since L1 has a pending
> exception, even though L1 may have already handled the exception and
> written a positive value for it's decrementer. This results in a loop of
> L1 trying to enter the L2 guest and L0 blocking the entry since L1 has
> an interrupt pending with the outcome being that L2 never gets to run
> and hangs.
> 
> Fix this by clearing any pending decrementer exceptions when L1 makes
> the H_ENTER_NESTED hcall since it won't do this if it's decrementer has
> gone negative, and anyway it's decrementer has been communicated to L0
> in the hdec_expires field and L0 will return control to L1 when this
> goes negative by delivering an H_DECREMENTER exception.
> 
> Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Tested-by: Laurent Vivier <lvivier@redhat.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/3c25ab35fbc8526ac0c9b298e8a78e7ad7a55479

cheers
