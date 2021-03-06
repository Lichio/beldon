package belog.admin;

import belog.pojo.Msg;
import belog.pojo.Page;
import belog.pojo.PageModel;
import belog.pojo.vo.*;
import belog.service.CategoryService;
import belog.service.LinksService;
import belog.utils.MsgUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * 链接前台控制器
 * Created by Beldon
 */
@Controller("adminLinkController")
@RequestMapping("/admin/link")
public class LinkController extends AdminBaseController {

    @Autowired
    private LinksService linksService;

    @Autowired
    @Qualifier("CategoryService")
    private CategoryService categoryService;

    @RequestMapping("/list")
    public String list(@ModelAttribute("page") Page page, Model model) {
        Page pm = linksService.findPage(page);
        model.addAttribute("pm", pm);
        return getTemplatePath("link/list");
    }

    @RequestMapping("/edit")
    public String edit(@RequestParam(defaultValue = "0", required = false) long id, Model model) {
        if (id != 0) {
            LinksVo linksVo = linksService.findById(id);
            model.addAttribute("link", linksVo);
        }
        List<Categorys> cats = categoryService.findCat(CategoryService.LINK_CATEGORY);
        model.addAttribute("cats", cats);
        return getTemplatePath("link/edit");
    }

    @RequestMapping("/ajaxEdit.json")
    @ResponseBody
    public Msg ajaxEdit(@ModelAttribute("link") LinksVo linksVo,@RequestParam(required = false) long[] catId) {
        List<CategoryVo> cats = new ArrayList<CategoryVo>();
        //分类
        if (catId != null) {
            for (int i = 0; i < catId.length; i++) {
                CategoryVo categoryVo = new CategoryVo();
                categoryVo.setId(catId[i]);
                cats.add(categoryVo);
            }
        }

        linksVo.setCats(cats);
        linksService.saveOrUpdate(linksVo);
        return MsgUtils.success();
    }


    @RequestMapping("/delete.json")
    @ResponseBody
    public Msg delete(long id) {
        if (0 == id) {
            return MsgUtils.error("请填入要删除的内容");
        }
        linksService.delete(id);
        return MsgUtils.success();
    }

    @RequestMapping("/cat_list")
    public String catList(Model model) {
        List<Categorys> categorysList = categoryService.findCat(CategoryService.LINK_CATEGORY);
        model.addAttribute("cats", categorysList);
        return getTemplatePath("link/cat_list");
    }

    @RequestMapping("/cat_edit")
    public String catEdit(int id, Model model) {
        CategoryVo cat = categoryService.findById(id);
        List<Categorys> categorysList = categoryService.findCat(CategoryService.LINK_CATEGORY);
        model.addAttribute("cats", categorysList);
        model.addAttribute("cat", cat);
        return getTemplatePath("link/cat_edit");
    }

    @RequestMapping("/ajaxEditCat.json")
    @ResponseBody
    public Msg ajaxEdit(@ModelAttribute CategoryVo categoryVo) {
        categoryVo.setTaxonomy(CategoryService.LINK_CATEGORY);
        categoryService.saveOrUpdate(categoryVo);
        return MsgUtils.success();
    }

    @RequestMapping("/deleteCat.json")
    @ResponseBody
    public Msg deleteCat(@RequestParam("id") long id) {
        categoryService.deleteById(id);
        return MsgUtils.success();
    }
}
