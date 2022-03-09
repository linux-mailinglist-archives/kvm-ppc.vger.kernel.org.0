Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807934D2B54
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Mar 2022 10:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiCIJGr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Mar 2022 04:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiCIJGq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Mar 2022 04:06:46 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B15D1409F5
        for <kvm-ppc@vger.kernel.org>; Wed,  9 Mar 2022 01:05:48 -0800 (PST)
Received: by gandalf.ozlabs.org (Postfix, from userid 1003)
        id 4KD5rl1WZ6z4xvJ; Wed,  9 Mar 2022 20:05:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.org;
        s=201707; t=1646816743;
        bh=2T185+CM5zT+UIvWa5+XhJAAAEtv7RH9ZWvqTwtU+mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JlVkLfQ9DbssAt8xQ4O1pJCG8OwtSn0FY9oCqLyiSH/EvOH8uCFsvR8p2RbIkeJXR
         HfYSy2kVE6++P5SWCqXSsR+Rd7ALsoi16h72zAYmz2zooRG/P6VJxiwpXYESOPWdKJ
         CbRPWSiK/iJTTMDvrPwzMsDsFYR2gTJyxTQSrR6TB4IYCzXD66aqKUV+b6nmHsnfQk
         IWl/qXLRVznmC9LyTwa8rxekeEcUHZZKe8gncg3sWThUo0cTw3trzOmrnB/fu3Uq3U
         Ofrovaod7P0tdWQQk86ylAEOfcwlKjXWj8DWIUCSbpZA9JdHczwZFnpvVXKDc2oakQ
         MFM1Y3j5fT/eA==
Date:   Wed, 9 Mar 2022 09:05:24 +0000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
        david@gibson.dropbear.id.au, clg@kaod.org, danielhb413@gmail.com
Subject: Re: [RFC PATCH] KVM: PPC: Book3S HV: Add KVM_CAP_PPC_GTSE
Message-ID: <Yiht1OBSvh4SK9vY@cleo>
References: <20220309012338.2527143-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309012338.2527143-1-farosas@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 08, 2022 at 10:23:38PM -0300, Fabiano Rosas wrote:
> This patch adds a new KVM capability to address a crash we're
> currently having inside the nested guest kernel when running with
> GTSE disabled in the nested hypervisor.

I think the patch needs to add a description of KVM_CAP_PPC_GTSE to
Documentation/virt/kvm/api.rst.

Regards,
Paul.
