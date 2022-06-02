Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B10953C14A
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 Jun 2022 01:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbiFBXWt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Jun 2022 19:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239025AbiFBXWs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Jun 2022 19:22:48 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2821B1EEE6
        for <kvm-ppc@vger.kernel.org>; Thu,  2 Jun 2022 16:22:48 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id t22-20020a0568301e3600b0060b333f7a1eso4487386otr.0
        for <kvm-ppc@vger.kernel.org>; Thu, 02 Jun 2022 16:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=hcfGt2fOR3MfVRfYNfEqIsZz7XKJ8AtS8n9LSzmvQx8=;
        b=KJXMGAETmcmbCiYvqCfTJiVZ+4gEDZbUChxG94/suEYMG9kHr5zftCfUCt5BRCtxF8
         sgt/smz4OY+dqKh8C4qXJapMmYt2UoTRYwpERkXJrCuiYkkCuqXEyDNZgfSyLiVoh4MO
         p7qiUC4+LRruXsPkgddFDDDvSLHGOUzTMljKyto/dD25mJTHEJ8IA8t32tVMn9RLf7Ug
         C2DN4Lq64s5iUejUyCBd60DBAjd8qeY3nFGzjm5VKSOOZVly4QEckorCuPS5TTWeFwSo
         PaL8kmbBflB5IJsHDrH9t7nQXcmdAG7oVKOAX71pqhRGIjv4Pxb9LO0vrChjsSwkA8P2
         YOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=hcfGt2fOR3MfVRfYNfEqIsZz7XKJ8AtS8n9LSzmvQx8=;
        b=LmXcWE8aOFtjXOAv7CGIRBexQCOi3NbBiCvUSED702iyeVqm/4C20/pNE1LXiRw4i7
         vp/easB6MPeMYD8zq8FfHXBGB8wyJZuEYXP8NN0fhSyLZRBZfZvtPH9HyzjWEd7FKnsW
         lxnkyok02wBQa6YexwQzPjYsQfgKLDQt8EVVy0yfxhApYr9wZH6Cb/nK9sFJ25u+nLp0
         yxuHnYFJS48fkqJwuuv11MfTM0goTrFlaQPTqVExblJHBU2H9NX76gJmVR1mdIB27d4z
         otmZWM2noAGVxKTv3a+QpsIPnIeSFICMGGYZfK30wNZu6DDofm+38byqzG44zBQGdSeW
         Cg9g==
X-Gm-Message-State: AOAM530Pdid0eYFd/kq6RDxyW5wBsSQ8C1st/96pgEO66AinALDzCKtM
        qztDXiuMG3opVU2OWh04pkPGlKx6+MN9bmdecFk=
X-Google-Smtp-Source: ABdhPJyQAgQt8DlzHrDObIP2tTrbzUy7cg5rp7uPSnHGsxxb++QpJ8BEve83Z9mEcYrmz4mVH75+G/tXd7BE7bXsGyY=
X-Received: by 2002:a9d:4d0a:0:b0:60b:4e36:b669 with SMTP id
 n10-20020a9d4d0a000000b0060b4e36b669mr3073540otf.146.1654212167441; Thu, 02
 Jun 2022 16:22:47 -0700 (PDT)
MIME-Version: 1.0
Sender: ogbundubuisi2@gmail.com
Received: by 2002:a05:6358:24a4:b0:a4:66c5:ca with HTTP; Thu, 2 Jun 2022
 16:22:47 -0700 (PDT)
From:   Bella Williams <bellawilliams9060@gmail.com>
Date:   Thu, 2 Jun 2022 23:22:47 +0000
X-Google-Sender-Auth: _-WBopQJsivhWsVyQAEGYOuAcdw
Message-ID: <CAGPSnphetJ8PitC5XWdE8z8qbTbwo4NgSLdJO2Ei2Gv2U9x4FA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

-- 

Hello Dear,
how are you today
My name is Bella Williams
I will share pictures and more details about me as soon as i hear from you
Thanks
