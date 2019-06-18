Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9B54A0CB
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Jun 2019 14:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfFRMaR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jun 2019 08:30:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:34104 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfFRMaR (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 18 Jun 2019 08:30:17 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x5ICTJJT030631;
        Tue, 18 Jun 2019 07:29:24 -0500
Message-ID: <a2494d627548d788650be4af0ee1d6ed700da134.camel@kernel.crashing.org>
Subject: Re: [PATCH kernel] powerpc/pci/of: Parse unassigned resources
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Russell Currey <ruscur@russell.cc>,
        "Oliver O'Halloran" <oohall@gmail.com>
Date:   Tue, 18 Jun 2019 22:29:19 +1000
In-Reply-To: <87sgs7ozsa.fsf@concordia.ellerman.id.au>
References: <20190614025916.123589-1-aik@ozlabs.ru>
         <87sgs7ozsa.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 2019-06-18 at 22:15 +1000, Michael Ellerman wrote:
> Alexey Kardashevskiy <aik@ozlabs.ru> writes:
> > The pseries platform uses the PCI_PROBE_DEVTREE method of PCI probing
> > which is basically reading "assigned-addresses" of every PCI device.
> > However if the property is missing or zero sized, then there is
> > no fallback of any kind and the PCI resources remain undiscovered, i.e.
> > pdev->resource[] array is empty.
> > 
> > This adds a fallback which parses the "reg" property in pretty much same
> > way except it marks resources as "unset" which later makes Linux assign
> > those resources with proper addresses.
> 
> What happens under PowerVM is the big question.
> 
> ie. if we see such a device under PowerVM and then do our own assignment
> what happens?

May or may not work ... EEH will be probably b0rked, but then it
shouldn't happen.

Basically PowerVM itself doesn't do anything special with PCI. It maps
a whole PHB (or virtual PHB) into the guest and doesn't care much
beyond that for MMIOs.

What you see in Linux getting in the way is RTAS. It's the one
assigning BAR values etc... within that region setup by the HV, but
RTAS is running in the guest, from the HV perspective it's all the same
really.

So if such a device did exist, RTAS would lose track but it would still
work from a HW/HV perspective. RTAS-driven services such as EEH would
probably fail though.

But in practice this shouldn't happen bcs RTAS will set assigned-
addresses on everything.

Cheers,
Ben.
 

