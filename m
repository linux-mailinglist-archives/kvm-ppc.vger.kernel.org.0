Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA0F34DC56
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Mar 2021 01:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhC2XRu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 29 Mar 2021 19:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhC2XRn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 29 Mar 2021 19:17:43 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B1CC061762
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Mar 2021 16:17:42 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i26so20851838lfl.1
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Mar 2021 16:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sFO+yW2jCZdBRnXdrq0wXHYP3wv34YwpYnQ4UfitiFY=;
        b=Qaf9zdqv5yo82PrwdBxCmcFuw1/GqrzLeSY+FRroL+8jhy2VbPpEk6/gM3keviMjj5
         ORGmnGvRsJPNgJR69VnQmxe4W4VzwaWpGKsdDdSn08sXCduc3a3fJHMM9984hrr79XoA
         VV8RMIKOJ7avmy6UwurjSuG/G+d2j/qnkNgyGezfP8HMTyzw2EjiX8TeI7ZFVjlj9nif
         /rzfyA7w8Eum95ooZsHCha0asY8fHQ0GhX/RSMDAs5G/Flb+yFhcFvtUBKpSQdJrFua9
         ZUUcib8o4nva8rYg7F86y3SEVK+EWmO99ftan+xGciAbgvBXAa/vAhxk3FKpXhc0bQOR
         hWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sFO+yW2jCZdBRnXdrq0wXHYP3wv34YwpYnQ4UfitiFY=;
        b=EgaBBZoDoRH4leefPOfp8bslXUzJ4+22vQKb8ILP9advQR8S+LzPyOoeHeRwK1Iac0
         iOXhyAkFU+V+FMEROul4E+Nrmi5I1NLWIpXXUUAh10CggmcA0CwunepOBpd9CPCrX1D1
         NjvmgO2h0qYiGaIkqmMRjt03bmqdDN23ZRmhEx0NG6p7W7SjUy4yX0gJTIcrJlHXsq0c
         vqQnXVlz0iIN7xB4tavfA0vCqRREUbBq1KibRwvLAR9IYIXvvcRybaROCQ4lTvIBovgW
         u2K70ZKqlyGCvvK/LOixgI6bPEg1LwTpsmRI7IedcSL9hg5RiLyZojzpt2LBH+PmHhzz
         tBvg==
X-Gm-Message-State: AOAM533PlX5yVm3a8UQ68/Op/e3inblc67MkvZJByezKIzLG+ZXO7r5Q
        XZrEm6pgeShI44k2a4PMieKAY76wUu2k7Wbx0tq/Mq/S7yBJeQ==
X-Google-Smtp-Source: ABdhPJwXUTB3xGwKQOzT6aDw1jufSTJ8B9srgp4Puq3KDIPw/uZIRacUJumCdu92ZwZGnzT8bnrJmFQmV6qi1czXn8E=
X-Received: by 2002:a05:6512:4c4:: with SMTP id w4mr18134688lfq.91.1617059861134;
 Mon, 29 Mar 2021 16:17:41 -0700 (PDT)
MIME-Version: 1.0
From:   Raz <raziebe@gmail.com>
Date:   Tue, 30 Mar 2021 02:17:29 +0300
Message-ID: <CAPB=Z-qtA5Toz-oGmsscb4VZ9ozVhs-nNzbvmsSPD=nvu1fa0w@mail.gmail.com>
Subject: Question regarding MMIO
To:     kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

I have a basic question regarding MMIO access.
When a command in EL1/EL0 performs an MMIO access, it creates a trap
to the kvm-hypervisor.
The command needs to be replayed again:
 1. Is the command replayed in EL2 ?
 2. If so, how ?
 3. If not, how MMIO is implemented in ARMv8 ?

thank you
