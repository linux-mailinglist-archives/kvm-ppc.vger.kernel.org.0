Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0334A1F3369
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jun 2020 07:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgFIF3R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jun 2020 01:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgFIF3Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jun 2020 01:29:16 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0E9C03E969
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Jun 2020 22:29:16 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 49gzFH0mcQz9sTG; Tue,  9 Jun 2020 15:29:06 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Ram Pai <linuxram@us.ibm.com>,
        kvm-ppc@vger.kernel.org
Cc:     andmike@linux.ibm.com, bauerman@linux.ibm.com, aik@ozlabs.ru,
        sukadev@linux.vnet.ibm.com, david@gibson.dropbear.id.au,
        groug@kaod.org, clg@fr.ibm.com
In-Reply-To: <20200426020518.GC5853@oc0525413822.ibm.com>
References: <1585211927-784-1-git-send-email-linuxram@us.ibm.com> <20200426020518.GC5853@oc0525413822.ibm.com>
Subject: Re: [PATCH v3] powerpc/XIVE: SVM: share the event-queue page with the Hypervisor.
Message-Id: <159168034199.1381411.13122286705469530819.b4-ty@ellerman.id.au>
Date:   Tue,  9 Jun 2020 15:29:06 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 25 Apr 2020 19:05:18 -0700, Ram Pai wrote:
> >From 10ea2eaf492ca3f22f67a5a63a2b7865e45299ad Mon Sep 17 00:00:00 2001
> From: Ram Pai <linuxram@us.ibm.com>
> Date: Mon, 24 Feb 2020 01:09:48 -0500
> Subject: [PATCH v3] powerpc/XIVE: SVM: share the event-queue page with the
>  Hypervisor.
> 
> XIVE interrupt controller uses an Event Queue (EQ) to enqueue event
> notifications when an exception occurs. The EQ is a single memory page
> provided by the O/S defining a circular buffer, one per server and
> priority couple.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/xive: Share the event-queue page with the Hypervisor.
      https://git.kernel.org/powerpc/c/094235222d41d68d35de18170058d94a96a82628

cheers
