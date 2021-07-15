Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6183C9E4A
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 14:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhGOMOj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 08:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbhGOMOj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 08:14:39 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445D0C06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 05:11:46 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4GQYBh4VVTz9sV8; Thu, 15 Jul 2021 22:11:40 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20210712013650.376325-1-npiggin@gmail.com>
References: <20210712013650.376325-1-npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV P9: Fix guest TM support
Message-Id: <162635108191.21941.16178288289762997581.b4-ty@ellerman.id.au>
Date:   Thu, 15 Jul 2021 22:11:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 12 Jul 2021 11:36:50 +1000, Nicholas Piggin wrote:
> The conversion to C introduced several bugs in TM handling that can
> cause host crashes with TM bad thing interrupts. Mostly just simple
> typos or missed logic in the conversion that got through due to my
> not testing TM in the guest sufficiently.
> 
> - Early TM emulation for the softpatch interrupt should be done if fake
>   suspend mode is _not_ active.
> 
> [...]

Applied to powerpc/fixes.

[1/1] KVM: PPC: Book3S HV P9: Fix guest TM support
      https://git.kernel.org/powerpc/c/e44fbdb68049539de9923ce4bad2d277aef54892

cheers
